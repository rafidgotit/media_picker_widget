import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../media_picker_widget.dart';
import 'widgets/loading_widget.dart';

class AlbumSelector extends StatelessWidget {
  AlbumSelector({
    required this.onSelect,
    required this.albums,
    required this.panelController,
    required this.decoration,
  });

  final ValueChanged<AssetPathEntity> onSelect;
  final List<AssetPathEntity> albums;
  final PanelController panelController;
  final PickerDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      final albumTiles = albums
          .map((album) => AlbumTile(
                album: album,
                onSelect: () => onSelect(album),
                decoration: decoration,
              ))
          .toList(growable: false);

      return SlidingUpPanel(
        controller: panelController,
        minHeight: 0,
        color: Theme.of(context).canvasColor,
        boxShadow: [],
        maxHeight: constrains.maxHeight,
        panelBuilder: (sc) {
          return ListView.builder(
            controller: sc,
            itemBuilder: (_, index) => albumTiles[index],
            itemCount: albumTiles.length,
          );
        },
      );
    });
  }
}

class AlbumTile extends StatelessWidget {
  AlbumTile({
    required this.album,
    required this.onSelect,
    required this.decoration,
  });

  final AssetPathEntity album;
  final VoidCallback onSelect;
  final PickerDecoration decoration;

  Future<Uint8List?> _getAlbumThumb(AssetPathEntity album) async {
    final media = await album.getAssetListPaged(page: 0, size: 1);

    if (media.isNotEmpty) {
      return media[0].thumbnailDataWithSize(ThumbnailSize(80, 80));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelect,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 80,
                height: 80,
                child: FutureBuilder(
                  future: _getAlbumThumb(album),
                  builder: _builder,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                album.name,
                style: decoration.albumTextStyle ??
                    TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
              ),
              SizedBox(
                width: 5,
              ),
              FutureBuilder(
                future: album.assetCountAsync,
                builder: _assetCountBuilder,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _assetCountBuilder(
    BuildContext context,
    AsyncSnapshot<int> snapshot,
  ) {
    return Text(
      '${snapshot.data ?? 0}',
      style: decoration.albumCountTextStyle ??
          TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
    );
  }

  Widget _builder(
    BuildContext context,
    AsyncSnapshot<Uint8List?> snapshot,
  ) {
    if (snapshot.hasError) {
      return Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.grey.shade400,
          size: 40,
        ),
      );
    }

    if (snapshot.connectionState == ConnectionState.done) {
      final albumThumb = snapshot.data;

      if (albumThumb == null) {
        return Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.grey.shade400,
            size: 40,
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            albumThumb,
            fit: BoxFit.cover,
          ),
        );
      }
    } else {
      return LoadingWidget(
        decoration: decoration,
      );
    }
  }
}
