import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:media_picker_widget/media_picker_widget.dart';

///This class will contain the necessary data for viewing list of media
class MediaViewModel{

  ///Unique id to identify
  final String id;

  ///A low resolution image to show as preview
  Uint8List? thumbnail;

  ///Get Thumbnail of the media file
  final Future<Uint8List?>? thumbnailAsync;

  ///Type of the media, Image/Video
  final MediaType? type;

  ///Duration of the video
  final Duration? videoDuration;

  MediaViewModel({
    required this.id,
    this.thumbnail,
    this.thumbnailAsync,
    this.type,
    this.videoDuration,
  });
}