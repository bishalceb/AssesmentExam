import 'dart:async';
import 'dart:io';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/database/assessmentdb.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:assesment/model/scopedModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';

class StudentRoundPic extends StatefulWidget {
  //final String studentCode;
  StudentData studentData;
  final Directory batchFolder;
  StudentRoundPic(this.studentData, this.batchFolder);
  @override
  _StudentRoundPicState createState() => _StudentRoundPicState();
}

class _StudentRoundPicState extends State<StudentRoundPic> {
  File _profilePic;
  File _adharPic;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<AssessmentDb> assessmentdb = List<AssessmentDb>();
  String _aadharDbImage;
  String _profileDbImage;
  Database db;
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  initState() {
    super.initState();
    fetchImage();
  }

  Future<void> getCamImage(String mode) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    File copiedImage = await image.copy(
        '${widget.batchFolder.path}/${mode == 'adhar' ? 'aadhar_' + '${widget.studentData.studentCode}.png' : 'profile_' + '${widget.studentData.studentCode}.png'}');

    setState(() {
      if (image != null) {
        mode == 'adhar' ? _adharPic = image : _profilePic = image;
        databaseHelper.insertData(AssessmentDb(
            fileName: copiedImage.path,
            batchId: basename(widget.batchFolder.path),
            priority: 3,
            studentCode: '',
            syncstatus: 0,
            type: 'student round'));
      }
    });
  }

  fetchImage() async {
    db = await databaseHelper.initDatabase();
    if (db != null) assessmentdb = await databaseHelper.fetchData();
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'student round' &&
          assessmentdb[i]
              .fileName
              .contains('adhar_${widget.studentData.studentCode}'))
        setState(() {
          _aadharDbImage = assessmentdb[i].fileName;
        });

      if (assessmentdb[i].type == 'student round' &&
          assessmentdb[i]
              .fileName
              .contains('profile_${widget.studentData.studentCode}'))
        setState(() {
          _profileDbImage = assessmentdb[i].fileName;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.studentData.name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(widget.studentData.studentRollNo),
                ],
              ),
              Row(
                children: <Widget>[
                  _profilePic == null && _profileDbImage == null
                      ? Image.asset(
                          'assets/img/placeholder.png',
                          height: 200.0,
                          width: 200.0,
                        )
                      : _profilePic != null && _profileDbImage == null
                          ? Image.file(
                              _profilePic,
                              height: 200.0,
                              width: 200.0,
                            )
                          : Image.file(
                              File(_profileDbImage),
                              height: 200.0,
                              width: 200.0,
                            ),
                  Expanded(
                    child: FlatButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text('Profile Picture'),
                      onPressed: () => getCamImage('profile'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: <Widget>[
                  _adharPic == null && _aadharDbImage == null
                      ? Image.asset(
                          'assets/img/placeholder.png',
                          height: 200.0,
                          width: 200.0,
                        )
                      : _aadharDbImage != null && _adharPic == null
                          ? Image.file(
                              File(_aadharDbImage),
                              height: 200.0,
                              width: 200.0,
                            )
                          : Image.file(
                              _adharPic,
                              height: 200.0,
                              width: 200.0,
                            ),
                  Expanded(
                    child: FlatButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text('Adhar Picture'),
                      onPressed: () => getCamImage('adhar'),
                    ),
                  ),
                ],
              ),
              RaisedButton(
                child: Text('NEXT'),
                onPressed: () {
                  if (_aadharDbImage == null ||
                      _profileDbImage == null ||
                      _adharPic == null ||
                      _profilePic == null) {
                    _scaffoldState.currentState.showSnackBar(SnackBar(
                      content: Text('Please take picture first'),
                    ));

                    /*  widget.studentData.absent = true;
                    widget.studentData.present = false;
                    widget.studentData.is_present = false; */

                    //Navigator.pop(context);
                  }
                  if (_aadharDbImage != null ||
                      _profileDbImage != null ||
                      _adharPic != null ||
                      _profilePic != null) {
                    widget.studentData.absent = false;
                    widget.studentData.present = true;
                    widget.studentData.is_present = true;
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
