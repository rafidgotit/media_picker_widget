import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:photo_manager/photo_manager.dart';

import 'media_view_model.dart';

abstract class MediaConversionService {
  static Future<Media> toMedia(MediaViewModel data, int index) async {
    var asset = await AssetEntity.fromId(data.id);
    if (asset == null) throw Exception('Asset not found');
    var media = Media(
      id: data.id,
      index: index,
      title: asset.title,
      thumbnail: data.thumbnail,
      size: asset.size,
      creationTime: asset.createDateTime,
      modifiedTime: asset.modifiedDateTime,
      latitude: asset.latitude,
      longitude: asset.longitude,
      file: await asset.file,
      mediaByte: await asset.originBytes,
      mediaType: data.type,
      videoDuration: asset.videoDuration,
    );
    return media;
  }

  static Future<List<Media>> toMediaList(List<MediaViewModel> data) async {
    var conversionTasks = <Future<Media>>[];
    for (int i = 0; i < data.length; i++) {
      conversionTasks.add(toMedia(data[i], i));
    }
    var results = await Future.wait(conversionTasks);
    results.sort((a, b) => (a.index ?? 0).compareTo(b.index ?? 0));
    return results;
  }

  static MediaViewModel toMediaView(Media data) {
    var media = MediaViewModel(
      id: data.id,
      thumbnail: data.thumbnail,
      type: data.mediaType,
    );
    return media;
  }

  static List<MediaViewModel> toMediaViewList(List<Media> data) {
    return data.map((e) => toMediaView(e)).toList();
  }
}
