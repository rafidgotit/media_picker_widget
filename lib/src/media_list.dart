import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../media_picker_widget.dart';
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
  final List<Media> previousList;
  final MediaCount? mediaCount;
  final PickerDecoration decoration;
  final ScrollController? scrollController;
  final Function(Media media, List<Media> selectedMedias) onMediaTilePressed;

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  final List<Widget> _mediaList = [];
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
        itemBuilder: (_, index) => _mediaList[index],
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
      final media = await _album.getAssetListPaged(
        page: _currentPage,
        size: 60,
      );
      if (media.isEmpty) {
        return;
      }
      List<Widget> temp = [];

      for (var asset in media) {
        temp.add(MediaTile(
          media: asset,
          onSelected: _onMediaTileSelected,
          isSelected: _isPreviouslySelected(asset),
          decoration: widget.decoration,
        ));
      }

      setState(() {
        _mediaList.addAll(temp);
        _currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  bool _isPreviouslySelected(AssetEntity media) {
    return _selectedMedias.any((element) => element.id == media.id);
  }

  void _onMediaTileSelected(bool isSelected, Media media) {
    if (isSelected) {
      setState(() => _selectedMedias.add(media));
    } else {
      setState(
          () => _selectedMedias.removeWhere((_media) => _media.id == media.id));
    }
    widget.onMediaTilePressed(media, _selectedMedias);
  }
}
