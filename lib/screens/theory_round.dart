import 'package:assesment/model/scopedModel.dart';
import 'package:assesment/theory_tab_screens/round1.dart';
import 'package:assesment/theory_tab_screens/round2.dart';
import 'package:assesment/theory_tab_screens/round3.dart';
import 'package:flutter/material.dart';

class Theory extends StatefulWidget {
  final MainScopedModel model;
  Theory(this.model);
  @override
  _TheoryState createState() => _TheoryState(model);
}

class _TheoryState extends State<Theory> {
  final MainScopedModel model;
  _TheoryState(this.model);
  //List<StudentData> students = List<StudentData>();

  @override
  void initState() {
    /*    int selected_batch = UserDetailApi.response[0].selected_batch;
    List<StudentData> student_data =
        UserDetailApi.response[0].batcheData[selected_batch].studentData;
    student_data.forEach((student) {
      if (student.is_present) {
        students.add(student);
      }
    }); */
    //model.addFirstRoundStudent(students);
    //students = model.firstRoundStudents;
    model.addFirstRoundStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: true,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Theory Round',
            ),
            bottom: TabBar(
              labelPadding: EdgeInsets.symmetric(vertical: 10.0),
              tabs: <Widget>[
                Text(
                  'Round 1',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Round 2',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Round 3',
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[Round1(), Round2(), Round3()],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.videocam),
          ),
        ),
      ),
    );
  }
}
