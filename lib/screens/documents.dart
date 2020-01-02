import 'dart:async';
import 'dart:io';
import 'package:assesment/screens/candidate_list.dart';
import 'package:assesment/screens/capture_image.dart';
import 'package:assesment/screens/capture_media.dart';
import 'package:flutter/material.dart';

class Documents extends StatefulWidget {
  final Directory bathFolder;
  Documents(this.bathFolder);
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
  static final card_color = Color(0xFF2f4050);
  static final card_text_color = Colors.white;
  static final card_border_color = Colors.black26;

  _buildDocumentsGridView() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(10.0),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _gridItems.length,
      itemBuilder: (context, int index) {
        return GestureDetector(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: new BorderSide(color: card_border_color, width: 2.0),
              ),
              color: card_color,
              elevation: 10,
              child: Center(
                child: Text(_gridItems[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: card_text_color, fontSize: 20.0)),
              ),
            ),
            onTap: () {
              index != 2
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CaptureImage(
                                mode: _gridItems[index],
                                batchFolder: widget.bathFolder,
                              )))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CandidateList(
                              index, _gridItems[index], widget.bathFolder)));
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
          body: Container(
              color: Colors.black26, child: _buildDocumentsGridView())),
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(false);
      },
    );
  }
}
