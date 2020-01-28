import 'dart:io';

import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/screens/capture_image.dart';
import 'package:assesment/screens/capture_media.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:flutter/material.dart';

class CandidateList extends StatefulWidget {
  final int index;
  final String mode;
  final Directory batchFolder;
  CandidateList(this.index, this.mode, this.batchFolder);
  @override
  _CandidateListState createState() => _CandidateListState();
}

class _CandidateListState extends State<CandidateList> {
  List<StudentData> students = [];
  List<StudentData> student_data;

  @override
  void initState() {
    int selected_batch = UserDetailApi.response[0].selected_batch;
    student_data =
        UserDetailApi.response[0].batchData[selected_batch].studentData;
    student_data.forEach((student) {
      if (student.is_present) {
        students.add(student);
      }
    });
    print('practical round init state called');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Candidate Feedback'),
          actions: <Widget>[
            PopupMenuButton<int>(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Go To Document Round'),
                  value: 1,
                ),
              ];
            }, onSelected: (index) {
              Navigator.of(context).pop(true);
            })
          ],
        ),
        body: students.length <= 0
            ? Center(
                child: Text('No any present student'),
              )
            : Container(
                color: Colors.black26,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
                      itemCount: students.length,
                      itemBuilder: (context, int index) {
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  students[index].name,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CaptureImage(
                                                index: widget.index,
                                                mode: widget.mode,
                                                batchFolder: widget.batchFolder,
                                                student: students[index],
                                              ))),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )));
  }
}
