import 'package:assesment/model/scopedModel.dart';
import 'package:assesment/model/student.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Round1 extends StatefulWidget {
  final MainScopedModel model;
  Round1([this.model]);
  @override
  _Round1State createState() => _Round1State(model);
}

class _Round1State extends State<Round1> {
  final MainScopedModel model;
  _Round1State(this.model);
  @override
  initState() {
    students = model.firstRoundStudent;
    super.initState();
  }

  List<Student> students = [];
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (BuildContext context, Widget child, MainScopedModel model) {
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
                      model.addStudentsToSecRound(students[index]);

                    })
              ],
            );
          },
        );
      },
    );
  }
}
