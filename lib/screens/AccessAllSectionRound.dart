import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
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
import 'package:assesment/screens/sync_summary.dart';
import 'package:assesment/screens/feedback_form.dart';
import 'package:assesment/screens/documents.dart';
import 'package:assesment/model/scopedModel.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'login_page.dart';

class AccessAllSectionRound extends StatefulWidget {
  final Directory batchFolder;
  AccessAllSectionRound(this.batchFolder);
  @override
  _AccessAllSectionRoundState createState() => _AccessAllSectionRoundState();
}

class _AccessAllSectionRoundState extends State<AccessAllSectionRound> {
  ProgressDialog pr;
  double percentage=0.0;
  List<String> _gridItems = [
    'Student Round',
    'Theory Round',
    'Viva Round',
    'Practical Round',
    'Center Infrastructure Round',
    'Documentation Round',
    'End of Assesment',
    'Billing Round',
    'Syncing summary'
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
  String _currentTime;

  FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://assessment-exam.appspot.com');

  fetchData() async {
    Database db = await databaseHelper.initDatabase();
    print("db===="+db.toString());
    print("assessmentdb==="+assessmentdb.toString());
    if (db != null) assessmentdb = await databaseHelper.fetchData();
  }

  @override
  void initState() {
    super.initState();
    percentage = 0.0;
        int selected_batch=UserDetailApi.response[0].selected_batch;
    student_data =
        UserDetailApi.response[0].batchData[selected_batch].studentData;
    _currentTime = DateFormat.jms().format(DateTime.now()).toString();
    UserDetailApi.response[0].batchData[selected_batch].current_timestamp=_currentTime;
    fetchData();
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
                        builder: (context) => SetPracticalRound(
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
                    MaterialPageRoute(builder: (context) => FeedbackForm(batchFolder: widget.batchFolder,)));
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
              else if (index == 8) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SyncSummasy(widget.batchFolder)));
              }

            });
      },
    );
  }

    uploadProctorProfile() async {
    print("come to proctor");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'proctor profile' &&
          assessmentdb[i].syncstatus == 0) {
        //print(assessmentdb[i].fileName);
        String firebaseStoragePath = 'Assessment/proctor_profile_${UserDetailApi.response[0].id}_${UserDetailApi.response[0].deviceId}.png';
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

   uploadCandidatePic() async{
    print("uploadCandidatePic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'candidate_feedback' &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        //print(assessmentdb[i].fileName);

        StorageUploadTask uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/candidate_${assessmentdb[i].studentCode}.png')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          /*setState(() {
            percentage=percentage+10.0;

          });*/
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

   uploadVtpFeedbackPic() async{
    print("uploadVtpFeedbackPic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'vtp_feedback_pic_' &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
         /* setState(() {
            percentage=percentage+5.0;
          });*/
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

   uploadExamAttendancePic() async{
    print("uploadExamAttendancePic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'exam_attendance_pic_' &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          /*setState(() {
            percentage=percentage+5.0;
          });*/
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

   uploadAssessorFeddbbackPic() async{
    print("uploadAssessorFeddbbackPic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'assessor_feedback_pic_' &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
        /*  setState(() {
            percentage=percentage+5.0;
          });*/
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

   uploadTrainingFeedbackPic() async{
    print("uploadTrainingFeedbackPic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'training_attendance_pic_' &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          /*setState(() {
            percentage=percentage+5.0;
          });*/
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

   uploadCodeOfConductPic() async{
    print("uploadCodeOfConductPic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'code_of_conduct_pic_' &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          /*setState(() {
            percentage=percentage+5.0;
          });*/
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

   uploadPlacementDocPic() async{
    print("uploadPlacementDocPic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'placement_doc_pic_' &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
         /* setState(() {
            percentage=percentage+5.0;
          });*/
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

   uploadGroupPhoto() async{
    print("uploadGroupPhoto");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'group_photo_' &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
         /* setState(() {
            percentage=percentage+5.0;
          });*/
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

   uploadStudentRoundPic() async{

    for (int i = 0; i < assessmentdb.length; i++) {
      //print("uploadStudentRoundPic"+widget.batchFolder.toString()+"==="+assessmentdb[i].batchId);
      if (assessmentdb[i].type == 'student round' &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        print("uploadStudentRoundPic"+widget.batchFolder.toString()+"==="+assessmentdb[i].batchId);
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          /*setState(() {
            percentage=percentage+5.0;
            print("percentage=="+percentage.toString());
          });*/
         print("percentage in complete=="+percentage.toString());
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

   uploadPracticalRoundPic() async{
    print("uploadPracticalRoundPic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('viva') ||
          assessmentdb[i].type.contains('practical') &&
              assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
            'Assessment/${basename(widget.batchFolder.path)}/${assessmentdb[i].type}.mp4')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          /* setState(() {
            percentage=percentage+10.0;
          });*/
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

  uploadVivaPic() async{
    print("Viva pic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('viva')  &&
              assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        print("uploadStudentRoundPic"+widget.batchFolder.toString()+"==="+assessmentdb[i].batchId);
        uploadTask = _storage
            .ref()
            .child(
            'Assessment/${basename(widget.batchFolder.path)}/${assessmentdb[i].type}.mp4')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          /* setState(() {
            percentage=percentage+10.0;
          });*/
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

   uploadTheoryRoundPic() async{
    print("uploadTheoryRoundPic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('theory_round_video_') &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          /*setState(() {
            percentage=percentage+5.0;
          });*/
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
   uploadBillingPic() async{
    print("uploadBillingPic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('billing_pic_') &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
            'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
        /*  setState(() {
            percentage=percentage+10.0;
          });*/
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

   uploadOtherPic() async{
    print("uploadOtherPic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('other_pic_') &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
            'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          /*setState(() {
            percentage=percentage+5.0;
          });*/
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

   uploadCenterInfraPic() async{
    print("uploadCenterInfraPic");
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type.contains('center_infra') &&
          assessmentdb[i].syncstatus == 0 && widget.batchFolder.toString().contains(assessmentdb[i].batchId)) {
        uploadTask = _storage
            .ref()
            .child(
                'Assessment/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          /*setState(() {
            percentage=percentage+10.0;
          });*/
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

  uploadFeedbackjson() async{
    String feedbackjson= await _readJSON();
    var outputAsUint8List = new Uint8List.fromList(feedbackjson.codeUnits);
    StorageUploadTask uploadTask = _storage
        .ref()
        .child(
        'Assessment/${basename(widget.batchFolder.path)}/proctor.json')
        .putData(outputAsUint8List);
  }
  Future<String> _readJSON() async {
    String text;
    try {
      final file = File('${widget.batchFolder.path}/proctor.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    text ??= "";
    return text;
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
    pr = new ProgressDialog(context, type: ProgressDialogType.Download);
    pr.style(message: 'Sync Your file...');

    pr.style(
      message: 'Sync Your file...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
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
                      ),
                      PopupMenuItem(
                        child: Text('Clear database'),
                        value: 3,
                      )
                    ];
                  }, onSelected: (index) async {
                    print("pop up index==" + index.toString());
                    if (index == 1) {
                      await uploadProctorProfile();
                      await uploadStudentRoundPic();
                      await uploadTheoryRoundPic();
                      await uploadPracticalRoundPic();
                      await uploadVivaPic();
                      await uploadCenterInfraPic();
                      await uploadExamAttendancePic();
                      await uploadAssessorFeddbbackPic();
                      await uploadCandidatePic();
                      await uploadTrainingFeedbackPic();
                      await uploadVtpFeedbackPic();
                      await uploadCodeOfConductPic();
                      await uploadPlacementDocPic();
                      await uploadGroupPhoto();
                      await uploadOtherPic();
                      await uploadBillingPic();
                      await uploadFeedbackjson();
                      percentage = 0.0;
                      pr.show();
                      pr.update(
                        progress: percentage,
                        message: "Please wait...",
                        progressWidget: Container(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator()),
                        maxProgress: 100.0,
                        progressTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400),
                        messageTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600),
                      );

                      Future.delayed(Duration(seconds: 10)).then((value) {
                        percentage = percentage + 30.0;
                        pr.update(
                            progress: percentage, message: "Few more seconds...");
                        print(percentage);
                        Future.delayed(Duration(seconds: 7)).then((value) {
                          percentage = percentage + 30.0;
                          pr.update(progress: percentage, message: "Almost done...");
                          print(percentage);

                          Future.delayed(Duration(seconds: 7)).then((value) {
                            pr.hide().whenComplete(() {
                              print(pr.isShowing());
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('All files uploaded successfully'),
                              ));
                            });
                            percentage = 0.0;
                          });
                        });
                      });


                      //_uploadProgressIndicator(context);

                    } else if(index==2){
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                              (Route<dynamic> route) => false);
                    }else if(index==3){
                      databaseHelper=null;
                    }
                  })
                ],
              ),
              floatingActionButton: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      await uploadProctorProfile();
                      await uploadStudentRoundPic();
                      await uploadTheoryRoundPic();
                      await uploadPracticalRoundPic();
                      await uploadVivaPic();
                      await uploadCenterInfraPic();
                      await uploadExamAttendancePic();
                      await uploadAssessorFeddbbackPic();
                      await uploadCandidatePic();
                      await uploadTrainingFeedbackPic();
                      await uploadVtpFeedbackPic();
                      await uploadCodeOfConductPic();
                      await uploadPlacementDocPic();
                      await uploadGroupPhoto();
                      await uploadOtherPic();
                      await uploadBillingPic();
                      await uploadFeedbackjson();
                      pr.show();
                      pr.update(
                        progress: percentage,
                        message: "Please wait...",
                        progressWidget: Container(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator()),
                        maxProgress: 100.0,
                        progressTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400),
                        messageTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600),
                      );

                      Future.delayed(Duration(seconds: 10)).then((value) {
                        percentage = percentage + 30.0;
                        pr.update(
                            progress: percentage, message: "Few more seconds...");
                        print(percentage);
                        Future.delayed(Duration(seconds: 7)).then((value) {
                          percentage = percentage + 30.0;
                          pr.update(progress: percentage, message: "Almost done...");
                          print(percentage);

                          Future.delayed(Duration(seconds: 7)).then((value) {
                            pr.hide().whenComplete(() {
                              print(pr.isShowing());
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('All files uploaded successfully'),
                              ));
                            });
                            percentage = 0.0;
                          });
                        });
                      });

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
