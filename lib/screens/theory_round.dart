import 'dart:io';

import 'package:assesment/screens/capture_video.dart';
import 'package:flutter/material.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:assesment/api/UserDetailApi.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:video_player/video_player.dart';

class Theory extends StatefulWidget {
  final Directory batchFolder;
  Theory(this.batchFolder);
  @override
  _TheoryState createState() => _TheoryState();
}

class _TheoryState extends State<Theory> {
  double height;
  double actual_height;
  BuildContext _scaffoldContext;
  List<StudentData> student_data;
  int visibleRound = 1;
  int total_round;
  List<Widget> _tabBarViews = [];
  List<Widget> _tabs = [];

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    int selected_batch = UserDetailApi.response[0].selected_batch;
    total_round = UserDetailApi.response[0].selected_round_no;
    student_data =
        UserDetailApi.response[0].batcheData[selected_batch].studentData;
  }

  @override
  void didChangeDependencies() {
    setState(() {
      for (int i = 1; i <= total_round; i++) {
        _tabBarViews.add(get1stRoundList());
      }
      for (int i = 1; i <= total_round; i++) {
        _tabs.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'Round $i',
            style: TextStyle(fontSize: 20.0, letterSpacing: 0.9),
          ),
        ));
      }
    });
    super.didChangeDependencies();
  }

/*   List<Widget> tabBarView() {
    for (int i = 1; i <= total_round; i++) {
      _tabBarViews.add(get1stRoundList());
    }
  }

  List<Widget> tabs() {
    for (int i = 1; i <= total_round; i++) {
      _tabs.add(Text('Round $i'));
    }
  } */

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: true,
      child: DefaultTabController(
        length: total_round,
        child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Theory Round',
            ),
            bottom: TabBar(
              isScrollable: true,
              onTap: (index) {
                print("index ==" + index.toString());
                int selectedtab = index + 1;
                setState(() {
                  visibleRound = selectedtab;
                });
              },
              labelPadding: EdgeInsets.symmetric(vertical: 10.0),
              tabs: _tabs.map((tabs) => tabs).toList(),
            ),
          ),
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: _tabBarViews.map((tabView) => tabView).toList()),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CaptureVideo(
                          batchFolder: widget.batchFolder,
                          mode: 'theory round',
                        ))),
            child: Icon(Icons.videocam),
          ),
        ),
      ),
    );
  }

  get1stRoundList() {
    height = MediaQuery.of(context).size.height;
    double percentage_height = 0.33 * height;
    actual_height = height - percentage_height;
    return Container(
      height: actual_height,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: _studentPageDesign,
        padding: EdgeInsets.all(0.0),
      ),
    );
  }

  Widget _studentPageDesign(BuildContext context, int index) {
    print("visible round==" + visibleRound.toString());
    print("condition check==" +
        student_data[index].isAdded.toString() +
        "  " +
        student_data[index].addedInRound.toString() +
        "  ");

    return !student_data[index].isAdded ||
            student_data[index].addedInRound == visibleRound ||
            student_data[index].addedInRound == 0
        ? Card(
            shape: RoundedRectangleBorder(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 150,
                  child: Text(
                    student_data[index].name,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2),
                  child: ToggleButtons(
                    borderColor: Colors.black26,
                    fillColor: Colors.pink,
                    borderWidth: 2,
                    selectedBorderColor: Colors.black26,
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Remove',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Add',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    onPressed: (int toggle_index) {
                      setState(() {
                        for (int i = 0; i < 2; i++) {
                          if (i == toggle_index) {
                            student_data[index].isRemoved = false;
                            student_data[index].isAdded = true;
                            student_data[index].addedInRound = visibleRound;
                          } else {
                            student_data[index].isRemoved = true;
                            student_data[index].isAdded = false;
                            student_data[index].addedInRound = visibleRound;
                          }
                        }
                      });
                    },
                    isSelected: [
                      student_data[index].isRemoved,
                      student_data[index].isAdded
                    ],
                  ),
                )
              ],
            ),
          )
        : Container();
  }
}
