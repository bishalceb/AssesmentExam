import 'dart:io';

import 'package:assesment/model/scopedModel.dart';
import 'package:assesment/screens/AccessAllSectionRound.dart';
import 'package:assesment/screens/studnt_round_pic.dart';
import 'package:flutter/material.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:assesment/api/UserDetailApi.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:scoped_model/scoped_model.dart';

class StudentList extends StatefulWidget {
  final Directory batchFolder;
  StudentList(this.batchFolder);
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  double height;
  double actual_height;
  BuildContext _scaffoldContext;
  List<StudentData> student_data;
  bool _isPresent = false;
  @override
  void initState() {
    super.initState();
    int selected_batch = UserDetailApi.response[0].selected_batch;
    student_data =
        UserDetailApi.response[0].batcheData[selected_batch].studentData;
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldContext = context;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Student List"),
        ),
        body: Container(
          color: prefix0.Colors.black26,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: getStdListBody(context)),
              Container(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
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
                        Navigator.of(context).pop();
                      }),
                )),
              ),
            ],
          ),
        ));
  }

  getStdListBody(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    double percentage_height = 0.33 * height;
    actual_height = height - percentage_height;
    return Container(
      height: actual_height,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: _studentPageDesign,
        padding: EdgeInsets.all(0.0),
      ),
    );
  }

  Widget _studentPageDesign(BuildContext context, int index) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: 150,
                child: Text(
                  student_data[index].name,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('RollNo.: ' + student_data[index].studentRollNo),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(2),
            child: ToggleButtons(
              borderColor: Colors.black26,
              fillColor: Colors.green,
              borderWidth: 2,
              selectedBorderColor: Colors.black26,
              selectedColor: Colors.white,
              borderRadius: BorderRadius.circular(0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Absent',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Present',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
              onPressed: (int toggle_index) {
                setState(() {
                  for (int i = 0; i < 2; i++) {
                    if (i == toggle_index) {
                      student_data[index].absent = false;
                      student_data[index].present = true;
                      student_data[index].is_present = true;
                    } else {
                      student_data[index].absent = true;
                      student_data[index].present = false;
                      student_data[index].is_present = false;
                    }
                    if (student_data[index].present)
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentRoundPic(
                                    student_data[index], widget.batchFolder)));
                      });
                  }
                });
              },
              isSelected: [
                student_data[index].absent,
                student_data[index].present
              ],
            ),
          )
        ],
      ),
    );
  }
}
