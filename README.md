# media_picker_widget

[![Build](https://img.shields.io/badge/pub-v1.0.6-%23009F00)](https://pub.dev/packages/media_picker_widget)
[![Build](https://img.shields.io/badge/licence-MIT-%23f16f12)](https://github.com/rafidgotit/media_picker_widget/blob/master/LICENSE)

A widget that picks media files from storage and allows you to place it anywhere in the widget tree. You can use this widget in a dialog, bottom sheet, or anywhere else as you wish. It supports picking single or multiple images or videos. Use the `PickerDecoration` class to decorate the UI.

![Demo](https://raw.githubusercontent.com/rafidgotit/media_picker_widget/master/resources/demo.gif)

If you find this widget useful, consider supporting the developer by [buying them a coffee](https://www.buymeacoffee.com/rafid).

<a href="https://www.buymeacoffee.com/rafid" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
media_picker_widget: $latest_version
```
The latest version of the package is   [![Build](https://img.shields.io/badge/pub-v1.0.6-%23009F00)](https://pub.dev/packages/media_picker_widget)

### Android

To use this widget on Android, you need to add the following permissions to your _AndroidManifest.xml_ file, located in `<project root>/android/app/src/main/AndroidManifest.xml`:
```
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

If your app targets `Android SDK 33`, as mentioned in the [Android 13 Behavior changes](https://developer.android.com/about/versions/13/behavior-changes-13), you have to add the following permissions as well:
```
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
```

### iOS

This plugin requires iOS 9.0 or higher.

Starting with version **0.8.1** the iOS implementation uses PHPicker to pick (multiple) images on iOS 14 or higher.
As a result of implementing PHPicker it becomes impossible to pick HEIC images on the iOS simulator in iOS 14+. This is a known issue. Please test this on a real device, or test with non-HEIC images until Apple solves this issue. [63426347 - Apple known issue](https://www.google.com/search?q=63426347+apple&sxsrf=ALeKk01YnTMid5S0PYvhL8GbgXJ40ZS[…]t=gws-wiz&ved=0ahUKEwjKh8XH_5HwAhWL_rsIHUmHDN8Q4dUDCA8&uact=5)

Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryUsageDescription` - describe why your app needs permission for the photo library. This is called _Privacy - Photo Library Usage Description_ in the visual editor.
* `NSCameraUsageDescription` - describe why your app needs access to the camera. This is called _Privacy - Camera Usage Description_ in the visual editor.
* `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone, if you intend to record videos. This is called _Privacy - Microphone Usage Description_ in the visual editor.

## Usage
Firstly, import in dart code:
```
import 'package:media_picker_widget/media_picker_widget.dart';
```

To use the `media_picker_widget`, follow these steps:

1. Make sure your app's `minSdkVersion` is set to `21` in the `app/build.gradle` file.

2. Within your Flutter widget tree, simply add the `MediaPicker` widget, which extends `StatefulWidget`. Here's an example:
```dart
MediaPicker(
  mediaList: mediaList, //let MediaPicker know which medias are already selected by passing the previous mediaList
  onPicked: (selectedList){
    print('Got Media ${selectedList.length}');
  },
  onCancel: ()=> print('Canceled'),
  mediaCount: MediaCount.single,
  mediaType: MediaType.image,
  decoration: PickerDecoration(),
)
```

### Customization
Customize the widget as needed. You can use the [`PickerDecoration`](https://pub.dev/documentation/media_picker_widget/latest/media_picker_widget/PickerDecoration-class.html) class to decorate the UI.

### Custom Header
New header customization have been added. `MediaPicker` widget has `HeaderBuilder` property. You can pass a `HeaderBuilder` to customize the header. `HeaderBuilder` is a function that returns a `Widget`. You can use `HeaderBuilder` to customize the header as you wish. You can use `MediaPickerHeader` class to get the default header. `MediaPickerHeader` class has a `MediaPickerHeaderProps` class that takes `MediaPicker` properties as parameters. You can use `MediaPickerHeaderProps` class to customize the header. 
Like this,
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
  headerBuilder: (context, albumPicker, onDone, onCancel) {
   return SizedBox(
      height: 46.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(onPressed: onDone, child: const Text('Back')),
          Expanded(child: Center(child: albumPicker)),
          TextButton(onPressed: onDone, child: const Text('Done')),
        ],
      ),
    );
  },
)
```


For more Information about the Classes, Enums, Functions etc, visit [API Reference](https://pub.dev/documentation/media_picker_widget/latest/).


## Dependencies
This package depends on the following packages :
- [photo_manager](https://pub.dev/packages/photo_manager)
- [image_picker](https://pub.dev/packages/image_picker)
- [sliding_up_panel](https://pub.dev/packages/sliding_up_panel)
