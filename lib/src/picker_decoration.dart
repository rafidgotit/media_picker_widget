part of media_picker_widget;

///[PickerDecoration] is used for decorating the UI
class PickerDecoration {
  ///Widget that will work as back button in picker
  final Widget? cancelIcon;

  ///Blur amount on select media
  final double blurStrength;

  ///Scale Amount of selected media
  final double scaleAmount;

  ///Color of selected media
  final Color selectedColor;

  ///assign number of Columns of Media Grid
  final int columnCount;

  ///set position of ActionBar, bottom or top
  final ActionBarPosition actionBarPosition;

  ///Album title text style
  final TextStyle? albumTitleStyle;

  ///Album text text style
  final TextStyle? albumTextStyle;

  ///Album's media count text style
  final TextStyle? albumCountTextStyle;

  ///text of select button
  final String completeText;

  ///text of no media
  final String? noMedia;

  ///text style of select button
  final TextStyle? completeTextStyle;

  ///style of select button
  final ButtonStyle? completeButtonStyle;

  ///loading widget to be used as media place holder until media loads
  final Widget? loadingWidget;

  ///[counterBuilder] is used to customize the selection counter on picked media in the list. As it is placed in [Stack] widget, you can use [Positioned]/[Align] widget to position it.
  ///[context] is the BuildContext of picker header
  ///[index] is the index of selected media in the list. Show nothing if it is null
  final Function(BuildContext context, int? index)? counterBuilder;

  ///If the file is video, a duration will be shown on media list. You can customize it using this builder
  final Function(BuildContext context, String? duration)? videoDurationBuilder;

  ///PickerDecoration constructor to be used for decorating the UI
  PickerDecoration({
    this.actionBarPosition = ActionBarPosition.top,
    this.cancelIcon,
    this.columnCount = 3,
    this.blurStrength = 10,
    this.scaleAmount = 1.2,
    this.albumTitleStyle,
    this.completeText = 'Continue',
    this.completeTextStyle,
    this.completeButtonStyle,
    this.loadingWidget,
    this.albumTextStyle,
    this.albumCountTextStyle,
    this.noMedia,
    this.videoDurationBuilder,
    this.counterBuilder,
    this.selectedColor = Colors.black26,
  });
}
