import 'package:assesment/model/scopedModel.dart';
import 'package:assesment/model/student.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Round2 extends StatefulWidget {
  final MainScopedModel model;
  Round2(this.model);
  @override
  _Round2State createState() => _Round2State(model);
}

class _Round2State extends State<Round2> {
  final MainScopedModel model;
  _Round2State(this.model);

  List<Student> students = [];

  @override
  void initState() {
    students = model.secRoundStudents;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, Widget child, MainScopedModel model) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          itemCount: students.length,
          itemBuilder: (context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  students[index].name,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                    child:
                        Text('${students[index].isAdded ? 'Remove' : 'Add'}'),
                    onPressed: () {
                      //model.selectStudent(students[index]);
                      model.addStudentsToThirdRound(students[index]);
                    })
              ],
            );
          },
        );
      },
    );
  }
}
