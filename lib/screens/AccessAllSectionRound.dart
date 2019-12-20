import 'dart:async';
import 'dart:io';
import 'package:assesment/screens/capture_video.dart';
import 'package:flutter/material.dart';
import 'package:assesment/screens/StudentList.dart';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/screens/SetTheoryRounds.dart';
import 'package:assesment/screens/practical_round.dart';
import 'package:assesment/screens/feedback_form.dart';
import 'package:assesment/screens/documents.dart';
import 'package:assesment/model/scopedModel.dart';

class AccessAllSectionRound extends StatefulWidget {
  final Directory batchFolder;
  AccessAllSectionRound(this.batchFolder);
  @override
  _AccessAllSectionRoundState createState() => _AccessAllSectionRoundState();
}

class _AccessAllSectionRoundState extends State<AccessAllSectionRound> {
  List<String> _gridItems = [
    'Student Round',
    'Theory Round',
    'Practical Round',
    'Center Infrastructure Round',
    'Documentation Round',
    'End of Assesment',
  ];
  static final card_color = Color(0xFF2f4050);
  static final card_text_color = Colors.white;
  static final card_border_color = Colors.black26;
  final MainScopedModel model = MainScopedModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("selected batch==" +
        UserDetailApi.response[0].selected_batch.toString());
  }

  _buildAllSectionGridView() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(10.0),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: _gridItems.length,
      itemBuilder: (context, int index) {
        return GestureDetector(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: new BorderSide(color: card_border_color, width: 2.0),
              ),
              color: card_color,
              elevation: 10,
              child: Center(
                child: Text(_gridItems[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: card_text_color, fontSize: 20.0)),
              ),
            ),
            onTap: () {
              if (index == 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentList(widget.batchFolder)));
              } else if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SetTheoryRound(widget.batchFolder)));
              } else if (index == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Practical(widget.batchFolder)));
              } else if (index == 3) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CaptureVideo(
                              mode: 'center infrastructure',
                              batchFolder: widget.batchFolder,
                            )));
              } else if (index == 4) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Documents(widget.batchFolder)));
              } else if (index == 5) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackForm()));
              }
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Dashboard'),
          ),
          body: _buildAllSectionGridView()),
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(false);
      },
    );
  }
}
