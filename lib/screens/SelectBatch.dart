import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:assesment/screens/AccessAllSectionRound.dart';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:path_provider/path_provider.dart';

class SelectBatch extends StatefulWidget {
  final Directory createPath;
  SelectBatch(this.createPath);
  @override
  _SelectBatchState createState() => _SelectBatchState();
}

class _SelectBatchState extends State<SelectBatch> {
  UserDetailApi userDetailApi;
  List<BatchData> batchData = UserDetailApi.response[0].batchData;
  String _value;
  String selected_batch_id;
  int _selected_postion = 0;
  List<String> spinnerItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < batchData.length; i++) {
      spinnerItems.add(batchData[i].batchNo.toString());
    }
    print("batch==" + spinnerItems.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Batch"),
      ),
      body: batchdesign(),
    );
  }

  Widget batchdesign() {
    return Container(
      color: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(50),
            child: prefix0.Center(
              child: Text(
                "Select Batch",
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
              decoration:
                  BoxDecoration(border: Border.all(color: Color(0xFF2f4050))),
              child: DropdownButton<String>(
                style: prefix0.TextStyle(fontSize: 20, color: Colors.black12),
                isExpanded: true,
                items:
                    spinnerItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String value) {
                  int position = 0;
                  for (int j = 0; j < batchData.length; j++) {
                    if (batchData[j].batchNo == value) {
                      position = j;
                      UserDetailApi.response[0].selected_batch = position;
                      selected_batch_id=UserDetailApi.response[0].batchData[position].id;
                    }
                  }
                  setState(() {
                    _value = value;
                    UserDetailApi.response[0].selected_batch = position;
                  });
                },
                hint: Text('Select Batch'),
                value: _value,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Center(
                child: Container(
              margin: EdgeInsets.only(top: 40.0),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                /* gradient: new LinearGradient(
                        colors: [
                          Theme.Colors.loginGradientEnd,
                          Theme.Colors.loginGradientStart
                        ],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),*/
              ),
              child: MaterialButton(
                  /* highlightColor: Colors.transparent,
                      splashColor: Theme.Colors.loginGradientEnd,*/
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
                  onPressed: () async {
                    Directory batchFolder = await Directory(
                            '${widget.createPath. path}/batch_${UserDetailApi.response[0].id}_$selected_batch_id')
                        .create(recursive: true);
                    print("batchFolder=="+batchFolder.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AccessAllSectionRound(batchFolder)));
                  }),
            )),
          )
        ],
      ),
    );
  }
}
