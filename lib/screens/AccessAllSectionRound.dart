import 'dart:async';
import 'dart:io';
import 'package:assesment/database/assessmentdb.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:assesment/screens/capture_video.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:assesment/screens/StudentList.dart';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/screens/SetTheoryRounds.dart';
import 'package:assesment/screens/practical_round.dart';
import 'package:assesment/screens/feedback_form.dart';
import 'package:assesment/screens/documents.dart';
import 'package:assesment/model/scopedModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

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
  List<AssessmentDb> assessmentdb = List<AssessmentDb>();
  DatabaseHelper databaseHelper = DatabaseHelper();

  FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://assessment-exam.appspot.com');

  fetchData() async {
    Database db = await databaseHelper.initDatabase();
    if (db != null) assessmentdb = await databaseHelper.fetchData();
  }

  @override
  void initState() {
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

  void upload() async {
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'proctor profile' &&
          assessmentdb[i].syncstatus == 0) {
        //print(assessmentdb[i].fileName);
        String firebaseStoragePath = 'AssessmentExam/proctor_profile.png';
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
      } else if (assessmentdb[i].type == 'candidate' &&
          assessmentdb[i].syncstatus == 0) {
        //print(assessmentdb[i].fileName);

        StorageUploadTask uploadTask = _storage
            .ref()
            .child(
                'AssessmentExam/${basename(widget.batchFolder.path)}/candidate_${assessmentdb[i].studentCode}.png')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: 'candidate',
              studentCode: assessmentdb[i].studentCode));
      } else if (assessmentdb[i].type == 'vtp_feedback_pic_' ||
          assessmentdb[i].type == 'exam_attendance_pic_' ||
          assessmentdb[i].type == 'assessor_feedback_pic_' ||
          assessmentdb[i].type == 'training_attendance_pic_' ||
          assessmentdb[i].type == 'code_of_conduct_pic_' ||
          assessmentdb[i].type == 'placement_doc_pic_' ||
          assessmentdb[i].type == 'group_photo_' &&
              assessmentdb[i].syncstatus == 0) {
        StorageUploadTask uploadTask = _storage
            .ref()
            .child(
                'AssessmentExam/${basename(widget.batchFolder.path)}/${assessmentdb[i].type}${i + 1}.png')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      } else if (assessmentdb[i].type == 'student round' &&
          assessmentdb[i].syncstatus == 0) {
        StorageUploadTask uploadTask = _storage
            .ref()
            .child(
                'AssessmentExam/${basename(widget.batchFolder.path)}/${basename(assessmentdb[i].fileName)}')
            .putFile(File(assessmentdb[i].fileName));
        if (uploadTask.isComplete)
          databaseHelper.updateData(AssessmentDb(
              fileName: assessmentdb[i].fileName,
              batchId: assessmentdb[i].batchId,
              priority: assessmentdb[i].priority,
              syncstatus: 1,
              type: assessmentdb[i].type,
              studentCode: assessmentdb[i].studentCode));
      } else {
        if (assessmentdb[i].syncstatus == 0) {
          StorageUploadTask uploadTask = _storage
              .ref()
              .child(
                  'AssessmentExam/${basename(widget.batchFolder.path)}/${assessmentdb[i].type}${i + 1}.mp4')
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
  }

  @override
  Widget build(BuildContext context) {
    fetchData();
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Dashboard'),
            actions: <Widget>[
              PopupMenuButton<int>(itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text('Sync'),
                    value: 1,
                  )
                ];
              }, onSelected: (_) {
                upload();
                print('popup menu pressed');
              })
            ],
          ),
          body: _buildAllSectionGridView()),
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(false);
      },
    );
  }
}
