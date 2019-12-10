import 'package:assesment/model/scopedModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Practical extends StatefulWidget {
  @override
  _PracticalState createState() => _PracticalState();
}

class _PracticalState extends State<Practical> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Practical Round'),
      ),
      body: ScopedModelDescendant<MainScopedModel>(
        builder: (context, Widget child, MainScopedModel model) {
          return ListView.builder(
            padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0,bottom: 5.0),
            itemCount: model.firstRoundStudent.length,
            itemBuilder: (context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.firstRoundStudent[index].name,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Roll no. ' +
                              model.firstRoundStudent[index].rollno.toString(),
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    ),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text('Practical'),
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  FlatButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text('Viva'),
                    onPressed: () {},
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
