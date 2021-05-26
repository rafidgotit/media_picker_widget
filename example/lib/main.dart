import 'package:flutter/material.dart';
import 'package:media_picker_widget/media_picker_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Picker',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Media> mediaList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker'),
      ),
      body: previewList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => openImagePicker(context),
      ),
    );
  }

  Widget previewList(){
    return Container(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: List.generate(mediaList.length, (index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 80,
            width: 80,
            child: Image.memory(mediaList[index].thumbnail, fit: BoxFit.cover,),
          ),
        )),
      ),
    );
  }

  void openImagePicker(BuildContext context){
    // openCamera(onCapture: (image){
    //   setState(()=> mediaList = [image]);
    // });
    showModalBottomSheet(context: context, builder: (context){
      return MediaPicker(
        mediaList: mediaList,
        onPick: (selectedList){
          setState(()=> mediaList = selectedList);
          Navigator.pop(context);
        },
        onCancel: ()=> Navigator.pop(context),
        mediaCount: MediaCount.single,
        mediaType: MediaType.image,
        decoration: PickerDecoration(
          actionBarPosition: ActionBarPosition.top,
          blurStrength: 2,
          completeText: 'Next',
        ),
      );
    });
  }
}