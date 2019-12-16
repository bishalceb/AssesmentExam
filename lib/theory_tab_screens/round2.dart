import 'package:assesment/model/scopedModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Round2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, Widget child, MainScopedModel model) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          itemCount: model.secRoundStudents.length,
          itemBuilder: (context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  model.secRoundStudents[index].name,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                    child: Text(
                        '${model.secRoundStudents[index].isAdded ? 'Remove' : 'Add'}'),
                    onPressed: () {
                      //model.selectStudent(students[index]);
                      model.addStudentsToThirdRound(
                          model.secRoundStudents[index]);
                    })
              ],
            );
          },
        );
      },
    );
  }
}
