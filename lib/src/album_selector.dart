import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../media_picker_widget.dart';
import 'widgets/loading_widget.dart';

class AlbumSelector extends StatefulWidget {
  AlbumSelector({required this.onSelect, required this.albums, required this.panelController, required this.decoration});

  final ValueChanged<AssetPathEntity> onSelect;
  final List<AssetPathEntity> albums;
  final PanelController panelController;
  final PickerDecoration decoration;

  @override
  _AlbumSelectorState createState() => _AlbumSelectorState();
}

class _AlbumSelectorState extends State<AlbumSelector> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return SlidingUpPanel(
        controller: widget.panelController,
        minHeight: 0,
        color: Theme.of(context).canvasColor,
        boxShadow: [],
        maxHeight: constrains.maxHeight,
        panelBuilder: (sc) {
          return ListView(
            controller: sc,
            children: List<Widget>.generate(
              widget.albums.length,
              (index) => AlbumTile(
                album: widget.albums[index],
                onSelect: () => widget.onSelect(widget.albums[index]),
                decoration: widget.decoration,
              ),
            ),
          );
        },
      );
    });
  }
}

class AlbumTile extends StatefulWidget {
  AlbumTile({required this.album, required this.onSelect, required this.decoration});

  final AssetPathEntity album;
  final VoidCallback onSelect;
  final PickerDecoration decoration;

  @override
  _AlbumTileState createState() => _AlbumTileState();
}

class _AlbumTileState extends State<AlbumTile> {
  Uint8List? albumThumb;
  bool hasError = false;

  @override
  void initState() {
    _getAlbumThumb(widget.album);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onSelect,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 80,
                height: 80,
                child: !hasError
                    ? albumThumb != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              albumThumb!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : LoadingWidget(
                            decoration: widget.decoration,
                          )
                    : Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.grey.shade400,
                          size: 40,
                        ),
                      ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.album.name,
                style: widget.decoration.albumTextStyle??TextStyle(color: Colors.black, fontSize: 18),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '${widget.album.assetCount}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getAlbumThumb(AssetPathEntity album) async {
    List<AssetEntity> media = await album.getAssetListPaged(0, 1);
    Uint8List? _thumbByte = await media[0].thumbDataWithSize(80, 80);
    if (_thumbByte != null)
      setState(() => albumThumb = _thumbByte);
    else
      setState(() => hasError = true);
  }
}
