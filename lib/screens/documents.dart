import 'dart:async';
import 'package:assesment/screens/capture_media.dart';
import 'package:flutter/material.dart';

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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CaptureMedia(index, _gridItems[index])));
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Documents'),
          ),
          body: _buildDocumentsGridView()),
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(false);
      },
    );
  }
}
