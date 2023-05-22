part of media_picker_widget;

///This class will contain the necessary data of selected media
class Media {
  ///File saved on local storage
  final File? file;

  ///Unique id to identify
  final String? id;

  ///A low resolution image to show as preview
  final Uint8List? thumbnail;

  ///The image file in bytes format
  final Uint8List? mediaByte;

  ///Image Dimensions
  final Size? size;

  ///Creation time of the media file on local storage
  final DateTime? creationTime;

  ///media name or title
  final String? title;

  ///Type of the media, Image/Video
  final MediaType? mediaType;

  Media({
    this.id,
    this.file,
    this.thumbnail,
    this.mediaByte,
    this.size,
    this.creationTime,
    this.title,
    this.mediaType,
  });
}
