# media_picker_widget
[![Build](https://img.shields.io/badge/pub-v0.0.8-%23009F00)](https://pub.dev/packages/media_picker_widget)
[![Build](https://img.shields.io/badge/licence-MIT-%23f16f12)](https://github.com/rafid08/media_picker_widget/blob/master/LICENSE)


 A widget that picks media files from storage and allows you to place anywhere in the widget tree. You can place use this widget in dialog, bottomsheet or anywhere as you wish. You can pick single or multiple images or videos. Use `PickerDecoration` class to decorate the UI.
 
<p>
  <img src="https://raw.githubusercontent.com/rafid08/media_picker_widget/master/resources/demo.gif" width=265/>
</p>


## Install
Add to `pubspec.yaml`.

The latest version is   [![Build](https://img.shields.io/badge/pub-v0.0.9-%23009F00)](https://pub.dev/packages/media_picker_widget)

```
media_picker_widget: $latest_version
```

### iOS

This plugin requires iOS 9.0 or higher.

Starting with version **0.8.1** the iOS implementation uses PHPicker to pick (multiple) images on iOS 14 or higher.
As a result of implementing PHPicker it becomes impossible to pick HEIC images on the iOS simulator in iOS 14+. This is a known issue. Please test this on a real device, or test with non-HEIC images until Apple solves this issue. [63426347 - Apple known issue](https://www.google.com/search?q=63426347+apple&sxsrf=ALeKk01YnTMid5S0PYvhL8GbgXJ40ZS[…]t=gws-wiz&ved=0ahUKEwjKh8XH_5HwAhWL_rsIHUmHDN8Q4dUDCA8&uact=5)

Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryUsageDescription` - describe why your app needs permission for the photo library. This is called _Privacy - Photo Library Usage Description_ in the visual editor.
* `NSCameraUsageDescription` - describe why your app needs access to the camera. This is called _Privacy - Camera Usage Description_ in the visual editor.
* `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone, if you intend to record videos. This is called _Privacy - Microphone Usage Description_ in the visual editor.

And import in dart code:
```
import 'package:media_picker_widget/media_picker_widget.dart';
```

## Usage
For android, it requires `minSdkVersion 21`. Change this in `app/build.gradle`.

In your widget tree, simple add the `MediaPicker` class that extends `StatefulWidget` and you are good to go!
```
MediaPicker(
  mediaList: mediaList, //let MediaPicker know which medias are already selected by passing the previous mediaList
  onPick: (selectedList){
    print('Got Media ${selectedList.length}');
  },
  onCancel: ()=> print('Canceled'),
  mediaCount: MediaCount.single,
  mediaType: MediaType.image,
  decoration: PickerDecoration(),
)
```

For more Information about the Classes, Enums, Funtions etc, visit API Reference.

### Note
This package has not been tested in IOS yet. If you find any issue, let me know by opening an Issue on **[Github](https://github.com/rafid08/media_picker_widget/issues)**

## Dependencies
This package depends on the following packages :
- [photo_manager](https://pub.dev/packages/photo_manager)
- [image_picker](https://pub.dev/packages/image_picker)
- [sliding_up_panel](https://pub.dev/packages/sliding_up_panel)
