import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  chooseImages() async { // 讀圖片需要時間，所以要用 async
    // Pick an image.
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // source: 來源
    if(image != null){
      setState(() {
        _image = File(image.path);
      });

    }
  }
  captureImages() async {
    // Pick an image.
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    // source: 來源
    if(image != null){
      setState(() {
        _image = File(image.path);
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              _image != null?Image.file(_image!):Icon(Icons.image, size: 150,),
            //當沒有圖片載入時顯示image icon
              ElevatedButton(onPressed: (){  // 按下按鈕時
                chooseImages();
              },onLongPress: (){  // 長按按鈕時
                captureImages();
              }, child: Text("Choose/ Capture"))
          ],
        ),
      ),
    );
  }
}
