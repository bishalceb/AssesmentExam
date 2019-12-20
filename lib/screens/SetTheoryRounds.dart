import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/screens/theory_round.dart';
import 'package:assesment/model/scopedModel.dart';

class SetTheoryRound extends StatefulWidget {
  final Directory batchFolder;
  SetTheoryRound(this.batchFolder);
  @override
  _SetTheoryRoundState createState() => _SetTheoryRoundState();
}

class _SetTheoryRoundState extends State<SetTheoryRound> {
  UserDetailApi userDetailApi;
  List<BatcheData> batcheData = UserDetailApi.response[0].batcheData;
  String _value;
  int _selected_postion = 0;
  List<String> spinnerItems = [
    'Round 1',
    'Round 2',
    'Round 3',
    'Round 4',
    'Round 5',
    'Round 6',
    'Round 7',
    'Round 8',
    'Round 9',
    'Round 10'
  ];
  final MainScopedModel model = MainScopedModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Round"),
      ),
      body: rounddsign(),
    );
  }

  Widget rounddsign() {
    return Container(
        color: Colors.black26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Text(
                  "Select No Of Rounds",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: "WorkSansBold"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 60, 15, 15),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF2f4050))),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    items: spinnerItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      int position = 1;
                      for (int i = 0; i < spinnerItems.length; i++) {
                        if (spinnerItems[i].toString() == value.toString()) {
                          position = i + 1;
                          UserDetailApi.response[0].selected_round_no =
                              position;
                          print("position==" + position.toString());
                        }
                      }
                      setState(() {
                        _value = value;
                        UserDetailApi.response[0].selected_round_no = position;
                      });
                    },
                    hint: Text('Select Rounds'),
                    value: _value,
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Center(
                  child: Container(
                margin: EdgeInsets.only(top: 40.0),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Theory(widget.batchFolder)));
                    }),
              )),
            )
          ],
        ));
  }
}
