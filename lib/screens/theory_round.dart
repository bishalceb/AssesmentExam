import 'package:assesment/model/scopedModel.dart';
import 'package:assesment/screens/practical_round.dart';
import 'package:assesment/theory_tab_screens/round1.dart';
import 'package:assesment/theory_tab_screens/round2.dart';
import 'package:assesment/theory_tab_screens/round3.dart';
import 'package:flutter/material.dart';

class Theory extends StatefulWidget {
  final MainScopedModel model;
  Theory(this.model);
  @override
  _TheoryState createState() => _TheoryState(model);
}

class _TheoryState extends State<Theory> {
  final MainScopedModel model;
  _TheoryState(this.model);

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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Practical()));
            },
            child: Icon(Icons.videocam),
          ),
        ),
      ),
    );
  }
}
