import 'package:flutter/material.dart';

import '../media_picker_widget.dart';

class HeaderController {
  HeaderController({
    this.updateSelection,
    this.closeAlbumDrawer,
  });

  final ValueChanged<List<Media>>? updateSelection;
  final VoidCallback? closeAlbumDrawer;
}
