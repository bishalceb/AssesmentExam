import 'package:assesment/model/scopedModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Round3 extends StatefulWidget {
  @override
  _Round3State createState() => _Round3State();
}

class _Round3State extends State<Round3> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
      builder: (context, Widget child, MainScopedModel model) {
        return ListView.builder(
          itemCount: model.thirdRoundStudents.length,
          itemBuilder: (context, int index) {
            return ListTile(
              title: Text(
                model.thirdRoundStudents[index].name,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }
}
