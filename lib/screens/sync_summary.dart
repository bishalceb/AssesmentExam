
import 'dart:async';
import 'dart:io';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/screens/capture_video.dart';
import 'package:assesment/style/theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:assesment/database/assessmentdb.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter/material.dart' as prefix0;

class SyncSummasy extends StatefulWidget {
  final Directory batchFolder;
  SyncSummasy(this.batchFolder);
  @override
  _SyncSummasyState createState() => _SyncSummasyState();
}

class _SyncSummasyState extends State<SyncSummasy> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<AssessmentDb> assessmentdb=List<AssessmentDb>();
  var _syncmethodcall;
  List<StudentData> students = [];
  List<String> syncFileName = [
    'proctor profile',
    'student round',
    'theory_round_video_',
    'viva',
    'practical',
    'center_infra',
    'exam_attendance_pic_',
    'assessor_feedback_pic_',
    'candidate_feedback',
    'training_attendance_pic_',
    'vtp_feedback_pic_',
    'code_of_conduct_pic_',
    'placement_doc_pic_',
    'group_photo_',
    'other_pic_',
    'billing_pic_',
  ];
  List<String> SyncFileNameStatus = ["sync","sync","sync","sync","sync","sync","sync","sync","sync","sync","sync","sync","sync","sync","sync"];
  List<StudentData> student_data;
  int selected_batch;

  _SyncSummasyState() {
    getDataFromLocalDataBase().then((val) => setState(() {
      print("comes here");
      _syncmethodcall = val;
    }));
  }

  fetchData() async {
    Database db = await databaseHelper.initDatabase();
    if (db != null) assessmentdb = await databaseHelper.fetchData();
  }

  @override
  void initState() {
    selected_batch = UserDetailApi.response[0].selected_batch;
    student_data =
        UserDetailApi.response[0].batchData[selected_batch].studentData;
   fetchData();
    print('practical round init state called');
    //super.initState();
  }

  Widget _buildNextButton() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
          child: Container(
        margin: EdgeInsets.only(top: 20.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: MaterialButton(
            color: Color(0xFF2f4050),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
              child: Text(
                "FINISH",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontFamily: "WorkSansBold"),
              ),
            ),
            onPressed: () {
              /*for (int i = 0; i < student_data.length; i++) {
                print("ispresent value==" +
                    student_data[i].is_present.toString());
              }*/
              Navigator.of(context).pop();
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>AccessAllSectionRound()));
            }),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*if(_syncmethodcall!=null){
      return new Container();
    }else {*/
      return Scaffold(
          appBar: AppBar(
            title: Text('Sync Summary Information'),
            actions: <Widget>[
              PopupMenuButton<int>(itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text('Go To Dashboard'),
                    value: 1,
                  ),
                ];
              }, onSelected: (index) {
                Navigator.of(context).pop(true);
              })
            ],
          ),
          body: Container(
            color: Colors.black26,
            child: Column(
              children: <Widget>[
                _syncmethodcall != null
                    ? Center(
                  child: Text(
                      'Please wait Your Sync Information is In process'),
                )
                    : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        top: 5.0, left: 10.0, right: 10.0, bottom: 5.0),
                    itemCount: syncFileName.length,
                    itemBuilder: (context, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      syncFileName[index],
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ) /*,
                                        Text(
                                          'Roll No. ' +
                                              students[index].studentRollNo,
                                          style: TextStyle(fontSize: 16.0),
                                        )*/
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              FlatButton(
                                color: SyncFileNameStatus[index] == "done"
                                    ? Color(0xFF004100)
                                    : Color(0xFF2f4050),
                                /*shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),*/
                                child: Text(
                                  SyncFileNameStatus[index] == "done"
                                      ? 'Done'
                                      : "Sync",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  /* setState(() {
                                        student_data[index].is_take_viva=true;
                                      });*/

                                  /* Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CaptureVideo(
                                              batchFolder: widget.batchFolder,
                                              mode: 'viva',
                                              studentCode: student_data[index]
                                                  .studentCode,
                                            )));*/
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildNextButton()
              ],
            ),
          ));
    //}
  }


  Future<String> databaseinfo() async {
    /*for(int i=0;i<syncFileName.length;i++){
      for(int j = 0; j < assessmentdb.length; j++){
        if(assessmentdb[j].type ==syncFileName[j] && assessmentdb[j].syncstatus == 1){
          print("file name="+assessmentdb[j].fileName);
          setState(() {
            SyncFileNameStatus[i]="done";
          });
        }
      }
    }*/
    print("assessmentdb.length=="+assessmentdb.length.toString());
    for (int i = 0; i < assessmentdb.length; i++) {
      print("type and status=="+assessmentdb[i].type+"=="+assessmentdb[i].syncstatus.toString());
      if (assessmentdb[i].type == 'proctor profile' &&
          assessmentdb[i].syncstatus == 1) {

      }
    }
    return "Sucess";
  }

  Future<String> getDataFromLocalDataBase() async {
    return await databaseinfo();
  }


}
