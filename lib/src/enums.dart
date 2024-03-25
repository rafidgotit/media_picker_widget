part of media_picker_widget;

/// Make picker to select multiple or single media file
enum MediaCount {
  /// Make picker to select single media file
  single,

  /// Make picker to select multiple media file
  multiple,
}

/// Media picker selection type
enum MediaType {
  /// Make picker to select only video file
  video,

  /// Make picker to select only image file
  image,

  /// Make picker to select any media file
  all,
}

/// Position of action bar of media picker
enum ActionBarPosition {
  /// Set action bar position top of media picker
  top,

  /// Set action bar position bottom of media picker
  bottom,
}
