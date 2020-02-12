import 'dart:async';
import 'dart:io';
import 'package:assesment/database/assessmentdb.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:assesment/screens/capture_video.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:assesment/screens/StudentList.dart';
import 'package:assesment/screens/capture_image.dart';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/screens/SetTheoryRounds.dart';
import 'package:assesment/screens/SetPracticalRounds.dart';
import 'package:assesment/screens/viva_round.dart';
import 'package:assesment/screens/feedback_form.dart';
import 'package:assesment/screens/documents.dart';
import 'package:assesment/model/scopedModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

import 'login_page.dart';

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
    'Viva Round',
    'Practical Round',
    'Center Infrastructure Round',
    'Documentation Round',
    'End of Assesment',
    'Billing Round',
  ];
  List<Color> card_border_color = [Colors.black26, Colors.black26, Colors.black26,Colors.black26, Colors.black26, Colors.black26,Colors.black26, Colors.black26,Colors.black26];
  static final card_color = Color(0xFF2f4050);
  static final card_text_color = Colors.white;
  //static final card_border_color = Colors.black26;
  static final test_completed_card_border_color = Colors.green;
  final MainScopedModel model = MainScopedModel();
  List<AssessmentDb> assessmentdb = List<AssessmentDb>();
  DatabaseHelper databaseHelper = DatabaseHelper();
  StorageUploadTask uploadTask;
  List<StudentData> student_data;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://assessment-exam.appspot.com');

  fetchData() async {
    Database db = await databaseHelper.initDatabase();
    if (db != null) assessmentdb = await databaseHelper.fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
        int selected_batch=UserDetailApi.response[0].selected_batch;
    student_data =
        UserDetailApi.response[0].batchData[selected_batch].studentData;
    setState(() {
      if(student_data[0].is_present){
        card_border_color[0]=Colors.green;
      }
      if(student_data[0].isAdded){
        card_border_color[1]=Colors.green;
        card_border_color[3]=Colors.green;
      }
      if(student_data[0].is_take_viva){
        card_border_color[2]=Colors.green;
      }
    });

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
                side: new BorderSide(color:card_border_color[index]
                    , width: 2.0),
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
                        builder: (context) => SetTheoryRound(
                            widget.batchFolder, "Theory Round")));
              } else if (index == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Viva(widget.batchFolder)));
              } else if (index == 3) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SetTheoryRound(
                            widget.batchFolder, "Practical Round")));
              } else if (index == 4) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CaptureVideo(
                              mode: 'center infrastructure',
                              batchFolder: widget.batchFolder,
                            )));
              } else if (index == 5) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Documents(widget.batchFolder)));
              }else if (index == 6) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackForm()));
              }
              else if (index == 7) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CaptureImage(
                          mode: _gridItems[index],
                          batchFolder: widget.batchFolder,
                        )));
              }

            });
      },
    );
  }

  void uploadProctorProfile() async {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'proctor profile' &&
          assessmentdb[i].syncstatus == 0) {
        //print(assessmentdb[i].fileName);
        String firebaseStoragePath = 'Assessment/proctor_profile.png';
        StorageUploadTask uploadTask = _storage
            .ref()
            .child(firebaseStoragePath)
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: 'proctor profile',
              studentCode: ''));
      }
    }
  }

  void uploadCandidatePic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'candidate' &&
          assessmentdb[i].syncstatus == 0) {
        //print(assessmentdb[i].fileName);

        StorageUploadTask uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/candidate_${assessmentdb[i].studentCode}.png')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: 'candidate_feedback',
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadVtpFeedbackPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'vtp_feedback_pic_' &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadExamAttendancePic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'exam_attendance_pic_' &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadAssessorFeddbbackPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'assessor_feedback_pic_' &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadTrainingFeedbackPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'training_attendance_pic_' &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadCodeOfConductPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'code_of_conduct_pic_' &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadPlacementDocPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'placement_doc_pic_' &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadGroupPhoto() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'group_photo_' &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadStudentRoundPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'student round' &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadPracticalRoundPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('viva') ||
          assessmentdb[i].type.contains('practical') &&
              assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${assessmentdb[i].type}.mp4')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadTheoryRoundPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('theory_round_video_') &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }
  void uploadBillingPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('billing_pic_') &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
            'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadOtherPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('other_pic_') &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
            'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  void uploadCenterInfraPic() {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('center_infra') &&
          assessmentdb[i].syncstatus == 0) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      }
    }
  }

  _uploadProgressIndicator(BuildContext context) {
    double progressPercentage;
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            title: StreamBuilder<StorageTaskEvent>(
              stream: uploadTask.events,
              builder: (context, snapshot) {
                var event = snapshot?.data?.snapshot;
                progressPercentage = event != null
                    ? event.bytesTransferred / event.totalByteCount
                    : 0;
                return Column(
                  children: <Widget>[
                    LinearProgressIndicator(
                      value: progressPercentage,
                    ),
                    Text('${(progressPercentage * 100).toStringAsFixed(2)}'),
                  ],
                );
              },
            ),
            actions: <Widget>[
              progressPercentage == 100.0
                  ? FlatButton(
                      child: Text('Okay'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : Container()
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: WillPopScope(
          child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Dashboard'),
                actions: <Widget>[
                  PopupMenuButton<int>(itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text('Sync'),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text('LogOut'),
                        value: 2,
                      )
                    ];
                  }, onSelected: (index) {
                    print("pop up index==" + index.toString());
                    if (index == 1) {
                      uploadProctorProfile();
                      uploadAssessorFeddbbackPic();
                      uploadCandidatePic();
                      uploadCenterInfraPic();
                      uploadCodeOfConductPic();
                      uploadExamAttendancePic();
                      uploadGroupPhoto();
                      uploadPlacementDocPic();
                      uploadPracticalRoundPic();
                      uploadStudentRoundPic();
                      uploadTheoryRoundPic();
                      uploadTrainingFeedbackPic();
                      uploadVtpFeedbackPic();
                      uploadBillingPic();
                      uploadOtherPic();
                      _uploadProgressIndicator(context);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('All files uploaded successfully'),
                      ));
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                              (Route<dynamic> route) => false);
                    }
                  })
                ],
              ),
              floatingActionButton: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    onPressed: (){
                      uploadProctorProfile();
                      uploadAssessorFeddbbackPic();
                      uploadCandidatePic();
                      uploadCenterInfraPic();
                      uploadCodeOfConductPic();
                      uploadExamAttendancePic();
                      uploadGroupPhoto();
                      uploadPlacementDocPic();
                      uploadPracticalRoundPic();
                      uploadStudentRoundPic();
                      uploadTheoryRoundPic();
                      uploadTrainingFeedbackPic();
                      uploadVtpFeedbackPic();
                      uploadBillingPic();
                      uploadOtherPic();
                      _uploadProgressIndicator(context);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('All files uploaded successfully'),
                      ));
                    },
                    icon: Icon(Icons.phone_android),
                    label: Text("Sync Your Data"),
                  ),
                ),
              ),
              body: _buildAllSectionGridView()),
          onWillPop: () {
            Navigator.of(context).pop(true);
            return Future.value(false);
          },
        )
    );

  }
}
