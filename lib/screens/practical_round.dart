import 'dart:io';

import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/screens/capture_video.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class Practical extends StatefulWidget {
  final Directory batchFolder;
  Practical(this.batchFolder);
  @override
  _PracticalState createState() => _PracticalState();
}

class _PracticalState extends State<Practical> {
  List<StudentData> students = [];
  List<StudentData> student_data;

  @override
  void initState() {
    int selected_batch = UserDetailApi.response[0].selected_batch;
    student_data =
        UserDetailApi.response[0].batcheData[selected_batch].studentData;
    student_data.forEach((student) {
      if (student.is_present) {
        students.add(student);
      }
    });
    print('practical round init state called');

    super.initState();
  }

  Widget _buildNextButton() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
          child: Container(
        margin: EdgeInsets.only(top: 20.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: MaterialButton(
            color: Color(0xFF2f4050),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
              child: Text(
                "NEXT",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontFamily: "WorkSansBold"),
              ),
            ),
            onPressed: () {
              for (int i = 0; i < student_data.length; i++) {
                print("ispresent value==" +
                    student_data[i].is_present.toString());
              }
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>AccessAllSectionRound()));
            }),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Practical Round'),
        ),
        body: Container(
          color: Colors.black26,
          child: Column(
            children: <Widget>[
              students.length <= 0
                  ? Center(
                      child: Text('No any present student'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
                        itemCount: students.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          students[index].name,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Roll No. ' +
                                              students[index].studentRollNo,
                                          style: TextStyle(fontSize: 16.0),
                                        )
                                      ],
                                    ),
                                  ),
                                  FlatButton(
                                    color: Color(0xFF2f4050),
                                    child: Text('Practical',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CaptureVideo(
                                                batchFolder: widget.batchFolder,
                                                mode: 'practical',
                                                studentCode: student_data[index]
                                                    .studentCode))),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  FlatButton(
                                    color: Color(0xFF2f4050),
                                    /*shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),*/
                                    child: Text(
                                      'Viva',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CaptureVideo(
                                                batchFolder: widget.batchFolder,
                                                mode: 'viva',
                                                studentCode: student_data[index]
                                                    .studentCode))),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              _buildNextButton()
            ],
          ),
        ));
  }
}
