import 'package:assesment/model/scopedModel.dart';
import 'package:assesment/theory_tab_screens/round1.dart';
import 'package:assesment/theory_tab_screens/round2.dart';
import 'package:assesment/theory_tab_screens/round3.dart';
import 'package:flutter/material.dart';
import '../api/UserDetailApi.dart';

class Theory extends StatefulWidget {
  final MainScopedModel model;
  Theory(this.model);
  @override
  _TheoryState createState() => _TheoryState(model);
}

class _TheoryState extends State<Theory> {
  final MainScopedModel model;
  _TheoryState(this.model);
  List<StudentData> student_data;

  @override
  void initState() {
    model.addStudent();
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
            children: <Widget>[Round1(model), Round2(model), Round3()],
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
