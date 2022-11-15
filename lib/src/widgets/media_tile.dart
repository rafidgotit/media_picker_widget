import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:media_picker_widget/src/widgets/jumping_button.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../media_picker_widget.dart';
import 'loading_widget.dart';

class MediaTile extends StatefulWidget {
  MediaTile({
    Key? key,
    required this.media,
    required this.onSelected,
    this.isSelected = false,
    required this.decoration,
  }) : super(key: key);

  final AssetEntity media;
  final Function(bool isSelected, Media media) onSelected;
  final bool isSelected;
  final PickerDecoration decoration;

  @override
  _MediaTileState createState() => _MediaTileState();
}

class _MediaTileState extends State<MediaTile>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late var _selected = widget.isSelected;

  final _duration = const Duration(milliseconds: 100);
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: _duration);
  late final _animation =
      Tween<double>(begin: 1.0, end: 1.3).animate(_animationController);

  void _onTap(Media media) {
    setState(() => _selected = !_selected);
    if (_selected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    widget.onSelected(_selected, media);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if (_selected) {
      _animationController.forward();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _convertToMedia(media: widget.media),
      builder: _builder,
    );
  }

  Widget _builder(
    BuildContext context,
    AsyncSnapshot<Media> snapshot,
  ) {
    if (snapshot.hasData) {
      final media = snapshot.data!;

      return Padding(
        padding: const EdgeInsets.all(0.5),
        child: Stack(
          children: [
            Positioned.fill(
              child: media.thumbnail != null
                  ? JumpingButton(
                      onTap: () => _onTap(media),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRect(
                              child: AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    final amount =
                                        (_animation.value - 1) * 3.33;

                                    return ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                        sigmaX: widget.decoration.blurStrength *
                                            amount,
                                        sigmaY: widget.decoration.blurStrength *
                                            amount,
                                      ),
                                      child: Transform.scale(
                                        scale: _animation.value,
                                        child: Image.memory(
                                          media.thumbnail!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Positioned.fill(
                            child: AnimatedOpacity(
                              opacity: _selected ? 1 : 0,
                              curve: Curves.easeOut,
                              duration: _duration,
                              child: ClipRect(
                                child: Container(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                          if (widget.media.type == AssetType.video)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5, bottom: 5),
                                child: Icon(
                                  Icons.videocam,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.grey.shade400,
                        size: 40,
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedOpacity(
                  curve: Curves.easeOut,
                  duration: _duration,
                  opacity: _selected ? 1 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.done,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return LoadingWidget(
        decoration: widget.decoration,
      );
    }
  }
}

Future<Media> _convertToMedia({required AssetEntity media}) async {
  var mediaType = MediaType.all;
  if (media.type == AssetType.video) mediaType = MediaType.video;
  if (media.type == AssetType.image) mediaType = MediaType.image;

  return Media(
    file: await media.file,
    mediaByte: await media.originBytes,
    thumbnail: await media.thumbnailDataWithSize(ThumbnailSize(200, 200)),
    id: media.id,
    size: media.size,
    title: media.title,
    creationTime: media.createDateTime,
    mediaType: mediaType,
  );
}
