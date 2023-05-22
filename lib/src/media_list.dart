import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../media_picker_widget.dart';
import 'media_view_model.dart';
import 'widgets/media_tile.dart';

class MediaList extends StatefulWidget {
  MediaList({
    required this.album,
    required this.previousList,
    this.mediaCount,
    required this.decoration,
    this.scrollController,
    required this.onMediaTilePressed,
  });

  final AssetPathEntity album;
  final List<MediaViewModel> previousList;
  final MediaCount? mediaCount;
  final PickerDecoration decoration;
  final ScrollController? scrollController;
  final Function(MediaViewModel media, List<MediaViewModel> selectedMedias) onMediaTilePressed;

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  final List<MediaViewModel> _mediaList = [];
  var _currentPage = 0;
  late var _lastPage = _currentPage;
  late AssetPathEntity _album = widget.album;
  late final _selectedMedias = [...widget.previousList];

  @override
  void initState() {
    _fetchNewMedia(refresh: true);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MediaList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _album = widget.album;
    final isRefresh = oldWidget.album.id != _album.id;
    if (isRefresh) {
      _fetchNewMedia(
        refresh: isRefresh,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return true;
      },
      child: GridView.builder(
        controller: widget.scrollController,
        itemCount: _mediaList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.decoration.columnCount,
        ),
        itemBuilder: (_, index) => MediaTile(
          media: _mediaList[index],
          onThumbnailLoad: (thumb) {
            _mediaList[index].thumbnail = thumb;
            setState(() {});
          },
          onSelected: _onMediaTileSelected,
          isSelected: _isPreviouslySelected(_mediaList[index]),
          decoration: widget.decoration,
        ),
      ),
    );
  }

  void _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (_currentPage != _lastPage) {
        _fetchNewMedia(
          refresh: false,
        );
      }
    }
  }

  void _fetchNewMedia({required bool refresh}) async {
    if (refresh) {
      setState(() {
        _currentPage = 0;
        _mediaList.clear();
      });
    }
    _lastPage = _currentPage;
    final result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized ||
        result == PermissionState.limited) {
      final newAssets = await _album.getAssetListPaged(
        page: _currentPage,
        size: 60,
      );
      if (newAssets.isEmpty) {
        return;
      }
      List<MediaViewModel> newMedias = [];

      // var tasks = <Future>[];
      for (var asset in newAssets) {
        // Future<dynamic> task = Future(() async {
        // });
        // tasks.add(task);
        var media = _toMediaViewModel(asset);
        newMedias.add(media);
      }
      // await Future.wait(tasks);

      setState(() {
        _mediaList.addAll(newMedias);
        _currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  bool _isPreviouslySelected(MediaViewModel media) {
    return _selectedMedias.any((element) => element.id == media.id);
  }

  void _onMediaTileSelected(bool isSelected, MediaViewModel media) {
    if (isSelected) {
      setState(() => _selectedMedias.add(media));
    } else {
      setState(
          () => _selectedMedias.removeWhere((_media) => _media.id == media.id));
    }
    widget.onMediaTilePressed(media, _selectedMedias);
  }

  static MediaViewModel _toMediaViewModel(AssetEntity entity) {
    var mediaType = MediaType.all;
    if (entity.type == AssetType.video) mediaType = MediaType.video;
    if (entity.type == AssetType.image) mediaType = MediaType.image;
    return MediaViewModel(
      id: entity.id,
      thumbnailAsync: entity.thumbnailDataWithSize(ThumbnailSize(200, 200)),
      type: mediaType,
      thumbnail: null,
    );
  }
}
