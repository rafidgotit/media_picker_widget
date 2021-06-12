import 'package:flutter/material.dart';

import '../media_picker_widget.dart';

class HeaderController {
  HeaderController();

  ValueChanged<List<Media>>? updateSelection;
  VoidCallback? closeAlbumDrawer;
}
