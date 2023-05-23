import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String result = '';
  late ImagePicker imagePicker;
  dynamic textRecognizer;  // 文字識別器變數


  @override
  void initState() {
    // implement initState
    super.initState();
    imagePicker = ImagePicker();

    // initialize detector 文字識別器 預設是檢測英文
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  _imgFromCamera() async {  // 用相機拍攝圖片
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    File image = File(pickedFile!.path);
    setState(() {
      _image = image;
      if (_image != null) {
        doTextRecognition();
      }
    });
  }

  _imgFromGallery() async {  // 從圖庫中選擇圖像
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path);
    setState(() {
      _image = image;
      if (_image != null) {
        doTextRecognition();
      }
    });
  }

  // perform text recognition
  doTextRecognition() async { // 文字識別前先將圖片轉成其他格式
    InputImage inputImage = InputImage.fromFile(_image!);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    setState(() {
      result = text;result = text;
    });
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Point<int>> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages; // 如果有多語言

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg2.jpg'), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              const SizedBox(
                width: 100,
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/notebook.png'),
                      fit: BoxFit.cover),
                ),
                height: 280,
                width: 250,
                margin: const EdgeInsets.only(top: 70),
                padding: const EdgeInsets.only(left: 28, bottom: 5, right: 18),
                child: SingleChildScrollView(
                    child: Text(
                      result,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 10),
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 140),
                child: Stack(children: <Widget>[
                  Center(
                    child: Image.asset(
                      'images/clipboard.png',
                      height: 240,
                      width: 240,
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _imgFromGallery,
                      onLongPress: _imgFromCamera,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: _image != null
                            ? Image.file(
                          _image!,
                          width: 140,
                          height: 192,
                          fit: BoxFit.fill,
                        )
                            : Container(
                          width: 140,
                          height: 150,
                          child: Icon(
                            Icons.find_in_page,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}