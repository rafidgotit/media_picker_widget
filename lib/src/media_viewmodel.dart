import 'dart:typed_data';

import 'package:media_picker_widget/media_picker_widget.dart';

///This class will contain the necessary data for viewing list of media
class MediaViewModel{

  ///Unique id to identify
  final String? id;

  ///A low resolution image to show as preview
  final Uint8List? thumbnail;

  ///Type of the media, Image/Video
  final MediaType? mediaType;

  MediaViewModel({
    this.id,
    this.thumbnail,
    this.mediaType,
  });
}