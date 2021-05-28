import 'package:flutter/material.dart';

import '../../media_picker_widget.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({required this.decoration});

  final PickerDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (decoration.loadingWidget != null) ? decoration.loadingWidget : CircularProgressIndicator(),
    );
  }
}
