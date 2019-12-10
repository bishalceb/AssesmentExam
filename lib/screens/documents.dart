import 'dart:io';
import 'package:flutter/material.dart';
import 'package:multi_media_picker/multi_media_picker.dart';


class Documents extends StatefulWidget {
  @override
  _DocumentsState createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  List<String> _gridItems = [
    'Exam Attendance',
    'Assessor Feedback',
    'Candidate Feedback',
    'Training Attendance',
    'VTP Feedback',
    'Code of Conduct',
    'Placements Documents',
    'Group Photo'
  ];
  List<File> _images = [];

  getImages(ImageSource source, bool singleImage) async {
    var images = await MultiMediaPicker.pickImages(
        source: source, singleImage: singleImage);
    setState(() {
      _images = images;
    });
  }

  _buildImageList() {
    return _images == null
        ? SizedBox()
        : ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            itemCount: _images.length,
            itemBuilder: (context, int index) {
              return Image.file(
                _images[index],
                height: 200.0,
                width: 200.0,
              );
            },
          );
  }

  _buildDocumentsGridView() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(10.0),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _gridItems.length,
      itemBuilder: (context, int index) {
        return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                _gridItems[index],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () {
              index == 2
                  ? getImages(ImageSource.camera, true)
                  : getImages(ImageSource.gallery, false);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(height: 600.0, child: _buildDocumentsGridView()),
            Container(
              child: _buildImageList(),
              height: 400.0,
            )
          ],
        ),
      ),
    );
  }
}
