part of media_picker_widget;

///This class will contain the necessary data of selected media
class Media {
  ///File saved on local storage
  File? file;

  ///Unique id to identify
  String? id;

  ///A low resolution image to show as preview
  Uint8List? thumbnail;

  ///The image file in bytes format
  Uint8List? mediaByte;

  ///Image Dimensions
  Size? size;

  ///Creation time of the media file on local storage
  DateTime? creationTime;

  ///media name or title
  String? title;

  ///Type of the media, Image/Video
  MediaType? mediaType;

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
