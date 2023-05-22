import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../media_picker_widget.dart';
import 'widgets/jumping_button.dart';

class Header extends StatefulWidget {
  Header({
    Key? key,
    required this.selectedAlbum,
    required this.onBack,
    required this.onDone,
    required this.albumController,
    this.mediaCount,
    required this.decoration,
    this.selectedMedias,
  }) : super(key: key);

  final AssetPathEntity selectedAlbum;
  final VoidCallback onBack;
  final PanelController albumController;
  final ValueChanged<List<MediaViewModel>> onDone;
  final MediaCount? mediaCount;
  final PickerDecoration decoration;
  final List<MediaViewModel>? selectedMedias;

  @override
  HeaderState createState() => HeaderState();
}

class HeaderState extends State<Header> with TickerProviderStateMixin {
  static const _arrowDown = 0.0;
  static const _arrowUp = 1.0;

  late List<MediaViewModel> _selectedMedia = [...?widget.selectedMedias];

  late final _arrowAnimController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 100),
  );

  late final _arrowAnimation = Tween<double>(
    begin: _arrowDown,
    end: _arrowUp,
  ).animate(_arrowAnimController);

  void updateSelection(List<MediaViewModel> selectedMediaList) {
    if (widget.mediaCount == MediaCount.multiple) {
      setState(() {
        _selectedMedia = selectedMediaList;
      });
    } else if (selectedMediaList.length == 1) {
      widget.onDone(selectedMediaList);
    }
  }

  void closeAlbumDrawer() {
    widget.albumController.close();
    _arrowAnimController.reverse();
  }

  void _onLabelPressed() {
    if (widget.albumController.isPanelOpen) {
      widget.albumController.close();
      _arrowAnimController.reverse();
    }
    if (widget.albumController.isPanelClosed) {
      widget.albumController.open();
      _arrowAnimController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 6.0,
            child: IconButton(
              icon: widget.decoration.cancelIcon ??
                  Icon(Icons.arrow_back_outlined),
              onPressed: () {
                if (_arrowAnimation.value == _arrowUp) {
                  _arrowAnimController.reverse();
                }
                widget.onBack();
              },
            ),
          ),
          JumpingButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return SlideTransition(
                      child: child,
                      position: Tween<Offset>(
                        begin: Offset(0.0, -0.5),
                        end: Offset(0.0, 0.0),
                      ).animate(animation),
                    );
                  },
                  child: Text(
                    widget.selectedAlbum.name,
                    style: widget.decoration.albumTitleStyle,
                    key: ValueKey<String>(widget.selectedAlbum.id),
                  ),
                ),
                AnimatedBuilder(
                  animation: _arrowAnimation,
                  builder: (context, child) => Transform.rotate(
                    angle: _arrowAnimation.value * pi,
                    child: Icon(
                      Icons.keyboard_arrow_up_outlined,
                      size: (widget.decoration.albumTitleStyle?.fontSize) !=
                              null
                          ? widget.decoration.albumTitleStyle!.fontSize! * 1.5
                          : 20,
                      color: widget.decoration.albumTitleStyle?.color ??
                          Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            onTap: _onLabelPressed,
          ),
          Visibility(
            visible: widget.mediaCount == MediaCount.multiple &&
                _selectedMedia.isNotEmpty,
            child: Positioned(
              right: 6.0,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 100),
                transitionBuilder: (
                  Widget child,
                  Animation<double> animation,
                ) {
                  return SlideTransition(
                    child: child,
                    position: Tween<Offset>(
                      begin: Offset(1, 0.0),
                      end: Offset(0.0, 0.0),
                    ).animate(animation),
                  );
                },
                child: TextButton(
                  key: Key('button'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.decoration.completeText,
                        style: widget.decoration.completeTextStyle ??
                            TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        ' (${_selectedMedia.length})',
                        style: TextStyle(
                          color: widget.decoration.completeTextStyle?.color ??
                              Colors.white,
                          fontSize: widget
                                      .decoration.completeTextStyle?.fontSize !=
                                  null
                              ? widget.decoration.completeTextStyle!.fontSize! *
                                  0.77
                              : 11,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  onPressed: _selectedMedia.length > 0
                      ? () => widget.onDone(_selectedMedia)
                      : null,
                  style: widget.decoration.completeButtonStyle ??
                      TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Media> getFinalList(List<Media> selectedMediaList) {
    return [];
  }
}
