part of media_picker_widget;

///The MediaPicker widget that will select media files form storage
class MediaPicker extends StatefulWidget {
  ///The MediaPicker constructor that will select media files form storage
  MediaPicker({
    required this.onPick,
    required this.mediaList,
    required this.onCancel,
    this.mediaCount = MediaCount.multiple,
    this.mediaType = MediaType.all,
    this.decoration,
    this.scrollController,
  });

  ///CallBack on image pick is done
  final ValueChanged<List<Media>> onPick;

  ///Previously selected list of media in your app
  final List<Media> mediaList;

  ///Callback on cancel the picking action
  final VoidCallback onCancel;

  ///make picker to select multiple or single media file
  final MediaCount mediaCount;

  ///Make picker to select specific type of media, video or image
  final MediaType mediaType;

  ///decorate the UI of picker
  final PickerDecoration? decoration;

  ///assign a scroll controller to Media GridView of Picker
  final ScrollController? scrollController;

  @override
  _MediaPickerState createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  late final _decoration = widget.decoration ?? PickerDecoration();

  final _albumController = PanelController();
  final _headerController = GlobalKey<HeaderState>();

  AssetPathEntity? _selectedAlbum;
  late List<Media> _selectedMedias = [...widget.mediaList];

  Future<List<AssetPathEntity>> _fetchAlbums() async {
    var type = RequestType.common;
    if (widget.mediaType == MediaType.all) {
      type = RequestType.common;
    } else if (widget.mediaType == MediaType.video) {
      type = RequestType.video;
    } else if (widget.mediaType == MediaType.image) {
      type = RequestType.image;
    }

    final result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized ||
        result == PermissionState.limited) {
      return await PhotoManager.getAssetPathList(type: type);
    } else {
      PhotoManager.openSetting();

      return [];
    }
  }

  void _onMediaTilePressed(Media media, List<Media> selectedMedias) {
    _headerController.currentState?.updateSelection(selectedMedias);

    setState(() {
      _selectedMedias = selectedMedias;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.mediaCount == MediaCount.multiple) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          _headerController.currentState?.updateSelection(_selectedMedias));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FutureBuilder(
        future: _fetchAlbums(),
        builder: _builder,
      ),
    );
  }

  void handleBackPress() {
    if (_albumController.isPanelOpen) {
      _albumController.close();
    } else {
      widget.onCancel();
    }
  }

  void _onAlbumSelected(AssetPathEntity album) {
    _headerController.currentState?.closeAlbumDrawer();
    setState(() => _selectedAlbum = album);
  }

  Widget _builder(
    BuildContext context,
    AsyncSnapshot<List<AssetPathEntity>> snapshot,
  ) {
    if (snapshot.hasData) {
      final albums = snapshot.data!;

      if (albums.isEmpty) {
        return NoMedia(text: _decoration.noMedia);
      } else {
        final defaultSelectedAlbum = albums[0];

        return Column(
          children: [
            if (_decoration.actionBarPosition == ActionBarPosition.top)
              Header(
                key: _headerController,
                onBack: handleBackPress,
                onDone: widget.onPick,
                albumController: _albumController,
                selectedAlbum: _selectedAlbum ?? defaultSelectedAlbum,
                mediaCount: widget.mediaCount,
                decoration: _decoration,
              ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: MediaList(
                      album: _selectedAlbum ?? defaultSelectedAlbum,
                      previousList: _selectedMedias,
                      mediaCount: widget.mediaCount,
                      decoration: _decoration,
                      scrollController: widget.scrollController,
                      onMediaTilePressed: _onMediaTilePressed,
                    ),
                  ),
                  AlbumSelector(
                    panelController: _albumController,
                    albums: albums,
                    decoration: _decoration,
                    onSelect: _onAlbumSelected,
                  ),
                ],
              ),
            ),
            if (_decoration.actionBarPosition == ActionBarPosition.bottom)
              Header(
                key: _headerController,
                onBack: handleBackPress,
                onDone: widget.onPick,
                albumController: _albumController,
                selectedAlbum: _selectedAlbum ?? defaultSelectedAlbum,
                mediaCount: widget.mediaCount,
                decoration: _decoration,
              ),
          ],
        );
      }
    } else {
      return LoadingWidget(
        decoration: _decoration,
      );
    }
  }
}

///call this function to capture and get media from camera
void openCamera({
  ///callback when capturing is done
  required ValueChanged<Media> onCapture,
}) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    final converted = Media(
      id: UniqueKey().toString(),
      thumbnail: await pickedFile.readAsBytes(),
      creationTime: DateTime.now(),
      mediaByte: await pickedFile.readAsBytes(),
      title: 'capturedImage',
    );

    onCapture(converted);
  }
}
