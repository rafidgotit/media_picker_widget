part of media_picker_widget;

///make picker to select multiple or single media file
enum MediaCount {
  ///make picker to select single media file
  single,

  ///make picker to select multiple media file
  multiple,
}

///Media picker selection type
enum MediaType {
  ///make picker to select only video file
  video,

  ///make picker to select only image file
  image,

  ///make picker to select any media file
  all,
}

///position of action bar of media picker
enum ActionBarPosition {
  ///set action bar position top of media picker
  top,

  ///set action bar position bottom of media picker
  bottom,
}
