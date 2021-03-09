import 'dart:io';

import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loding = true;
  File _image;
  List _outpur;
  final picker = ImagePicker();


  @override
  void initState() {
    super.initState();

    loadModel().then((value)
    {
      setState(() {

      });
    });
  }

  dectectImage(File image) async {
    var outpur = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _outpur = outpur;
      _loding = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  @override
  void dispose() {
    super.dispose();
  }

  picImage()async
  {
    var image = await picker.getImage(source: ImageSource.camera);
        if(image == null)
          return null;
        setState(() {
          _image = File(image.path);
        });

  }
  picImageGallery()async
  {
    var image = await picker.getImage(source: ImageSource.gallery);
    if(image == null)
      return null;
    setState(() {
      _image = File(image.path);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Text("Fahamin", style: TextStyle(color: Colors.red, fontSize: 20)),
            SizedBox(
              height: 5,
            ),
            Text("Detector APP",
                style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w500,
                    fontSize: 20)),
            SizedBox(
              height: 50,
            ),
            Center(
              child: _loding
                  ? Container(
                      width: 350,
                      child: Column(
                        children: [
                          Image.asset("assets/icat.png"),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    )
                  : Container(
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      child: Image.file(_image ),

                    ),
                    SizedBox(height: 20,),
                    _outpur != null ? Text('${_outpur[0]['label']}',
                        style: TextStyle(color: Colors.black,fontSize: 150)) : Container(

                    ),
                    SizedBox(height: 15,)
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      picImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 250,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text("Capture a photo"),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      picImageGallery();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 250,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text("Select a photo"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
