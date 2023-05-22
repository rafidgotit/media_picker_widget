part of media_picker_widget;


///This class will contain the necessary data for viewing list of media
class MediaViewModel{

  ///Unique id to identify
  final String? id;

  ///A low resolution image to show as preview
  Uint8List? thumbnail;

  ///Get Thumbnail of the media file
  final Future<Uint8List?>? thumbnailAsync;

  ///Type of the media, Image/Video
  final MediaType? type;

  MediaViewModel({
    this.id,
    this.thumbnail,
    this.thumbnailAsync,
    this.type,
  });
}