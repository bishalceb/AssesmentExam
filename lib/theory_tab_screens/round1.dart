import 'package:assesment/model/scopedModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Round1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (BuildContext context, Widget child, MainScopedModel model) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          itemCount: model.firstRoundStudents.length,
          itemBuilder: (context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  model.firstRoundStudents[index].name,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                    child: Text(
                        '${model.firstRoundStudents[index].isAdded ? 'Remove' : 'Add'}'),
                    onPressed: () {
                      model.addStudentsToSecRound(
                          model.firstRoundStudents[index]);
                    })
              ],
            );
          },
        );
      },
    );
  }
}
