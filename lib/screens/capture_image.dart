import 'dart:async';
import 'dart:io';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/database/assessmentdb.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

class CaptureImage extends StatefulWidget {
  final int index;
  final String mode;
  final StudentData student;
  final Directory batchFolder;
  CaptureImage({this.index, this.mode, this.student, this.batchFolder});
  @override
  _CaptureImageState createState() => _CaptureImageState(mode);
}

class _CaptureImageState extends State<CaptureImage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  File _image;
  List<File> _images = [];
  String imageName;
  Database db;
  List<AssessmentDb> assessmentdb = List<AssessmentDb>();
  List<String> _dbImages = List<String>();
  String _dbImage;

  final String mode;
  _CaptureImageState(this.mode);

  @override
  initState() {
    super.initState();
    loadImage(mode);
  }

  loadImage(String mode) async {
    switch (mode) {
      case 'Assessor Feedback':
        await fetchAssessorImage();
        break;
      case 'Exam Attendance':
        await fetchExamAttendanceImage();
        break;
      case 'Candidate Feedback':
        await fetchCandidateImage();
        break;
      case 'Training Attendance':
        await fetchTrainingImage();
        break;
      case 'VTP Feedback':
        await fetchVtpImage();
        break;
      case 'Code of Conduct':
        await fetchCocImage();
        break;
      case 'Placements Documents':
        await fetchPlacementImage();
        break;
      case 'Group Photo':
        await fetchGroupImage();
        break;
    }
  }

  Future<void> getCamImage() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    if (image == null) return;
    setState(() {
      if (image != null)
        mode == 'Candidate Feedback' ? _image = image : _images.add(image);
    });

    switch (widget.mode) {
      case 'Assessor Feedback':
        saveAssessorImage();
        break;
      case 'Exam Attendance':
        saveExamAttendanceImage();
        break;
      case 'Candidate Feedback':
        saveCandidateImage();
        break;
      case 'Training Attendance':
        saveTrainingImage();
        break;
      case 'VTP Feedback':
        saveVtpImage();
        break;
      case 'Code of Conduct':
        saveCocImage();
        break;
      case 'Placements Documents':
        savePlacementImage();
        break;
      case 'Group Photo':
        saveGroupImage();
        break;
    }
  }

  saveExamAttendanceImage() async {
    for (int i = 0; i < _images.length; i++) {
      File copiedImagePath = await _images[i]
          .copy('${widget.batchFolder.path}/exam_attendance_pic_${i + 1}.png');

      AssessmentDb a = AssessmentDb(
        fileName: copiedImagePath.path,
        batchId: Path.basename(widget.batchFolder.path),
        priority: 1,
        syncstatus: 0,
        type: 'exam_attendance_pic_',
        studentCode: '',
      );
      await _databaseHelper.insertData(a);
    }
  }

  saveAssessorImage() async {
    for (int i = 0; i < _images.length; i++) {
      File copiedImagePath = await _images[i].copy(
          '${widget.batchFolder.path}/assessor_feedback_pic_${i + 1}.png');

      AssessmentDb a = AssessmentDb(
        fileName: copiedImagePath.path,
        batchId: Path.basename(widget.batchFolder.path),
        priority: 1,
        syncstatus: 0,
        type: 'assessor_feedback_pic_',
        studentCode: '',
      );
      await _databaseHelper.insertData(a);
    }
  }

  saveCandidateImage() async {
    if (widget.mode == 'Candidate Feedback') {
      File copiedImagePath = await _image.copy(
          '${widget.batchFolder.path}/candidate_${widget.student.studentCode}.png');
      AssessmentDb a = AssessmentDb(
        fileName: copiedImagePath.path,
        batchId: Path.basename(widget.batchFolder.path),
        priority: 1,
        syncstatus: 0,
        type: 'candidate',
        studentCode: widget.student.studentCode,
      );
      await _databaseHelper.insertData(a);
    }
  }

  saveTrainingImage() async {
    for (int i = 0; i < _images.length; i++) {
      File copiedImagePath = await _images[i].copy(
          '${widget.batchFolder.path}/training_attendance_pic_${i + 1}.png');

      AssessmentDb a = AssessmentDb(
        fileName: copiedImagePath.path,
        batchId: Path.basename(widget.batchFolder.path),
        priority: 1,
        syncstatus: 0,
        type: 'training_attendance_pic_',
        studentCode: '',
      );
      await _databaseHelper.insertData(a);
    }
  }

  saveVtpImage() async {
    for (int i = 0; i < _images.length; i++) {
      File copiedImagePath = await _images[i]
          .copy('${widget.batchFolder.path}/vtp_feedback_pic_${i + 1}.png');

      AssessmentDb a = AssessmentDb(
        fileName: copiedImagePath.path,
        batchId: Path.basename(widget.batchFolder.path),
        priority: 1,
        syncstatus: 0,
        type: 'vtp_feedback_pic_',
        studentCode: '',
      );
      await _databaseHelper.insertData(a);
    }
  }

  saveCocImage() async {
    for (int i = 0; i < _images.length; i++) {
      File copiedImagePath = await _images[i]
          .copy('${widget.batchFolder.path}/code_of_conduct_pic_${i + 1}.png');
      AssessmentDb a = AssessmentDb(
        fileName: copiedImagePath.path,
        batchId: Path.basename(widget.batchFolder.path),
        priority: 1,
        syncstatus: 0,
        type: 'code_of_conduct_pic_',
        studentCode: '',
      );
      await _databaseHelper.insertData(a);
    }
  }

  savePlacementImage() async {
    for (int i = 0; i < _images.length; i++) {
      File copiedImagePath = await _images[i]
          .copy('${widget.batchFolder.path}/placement_doc_pic_${i + 1}.png');

      AssessmentDb a = AssessmentDb(
        fileName: copiedImagePath.path,
        batchId: Path.basename(widget.batchFolder.path),
        priority: 1,
        syncstatus: 0,
        type: 'placement_doc_pic_',
        studentCode: '',
      );
      await _databaseHelper.insertData(a);
    }
  }

  saveGroupImage() async {
    for (int i = 0; i < _images.length; i++) {
      File copiedImagePath = await _images[i]
          .copy('${widget.batchFolder.path}/group_photo_${i + 1}.png');

      AssessmentDb a = AssessmentDb(
        fileName: copiedImagePath.path,
        batchId: Path.basename(widget.batchFolder.path),
        priority: 1,
        syncstatus: 0,
        type: 'group_photo_',
        studentCode: '',
      );
      _databaseHelper.insertData(a);
    }
  }

  fetchCandidateImage() async {
    db = await _databaseHelper.initDatabase();
    if (db != null) assessmentdb = await _databaseHelper.fetchData();

    for (int i = 0; i < assessmentdb.length; i++) {
      if (widget.mode == 'Candidate Feedback' &&
          assessmentdb[i].type == 'candidate')
        setState(() {
          _dbImage = assessmentdb[i].fileName;
        });
    }
  }

  fetchExamAttendanceImage() async {
    db = await _databaseHelper.initDatabase();
    if (db != null) assessmentdb = await _databaseHelper.fetchData();

/*     int i = 0;
    while (i < assessmentdb.length) {
      print('exam attendance pic:${assessmentdb[i].fileName}');
      if (assessmentdb[i].fileName.contains('exam_attendance_pic_${i + 1}')) {
        print('exam pic:${assessmentdb[i].fileName}');
        setState(() {
          _dbImages.add(assessmentdb[i].fileName);
        });
        i++;
      }
    } */
    for (int i = 0; i < assessmentdb.length; i++) {
      if (mode == 'Exam Attendance' &&
          assessmentdb[i].type == 'exam_attendance_pic_') {
        print('exam attendance pic:${assessmentdb[i].fileName}');
        setState(() {
          _dbImages.add(assessmentdb[i].fileName);
        });
      }
    }
  }

  fetchAssessorImage() async {
    db = await _databaseHelper.initDatabase();
    if (db != null) assessmentdb = await _databaseHelper.fetchData();

    /*  assessmentdb.forEach((f) {
      if (mode == 'Assessor Feedback' &&
          f.fileName == assessmentdb[assessmentdb.indexOf(f)].fileName)
        setState(() {
          _dbImages.add(f.fileName);
        });
    }); */

    for (int i = 0; i < assessmentdb.length; i++) {
      if (mode == 'Assessor Feedback' &&
          assessmentdb[i].type == 'assessor_feedback_pic_')
        setState(() {
          _dbImages.add(assessmentdb[i].fileName);
        });
    }
  }

  fetchTrainingImage() async {
    db = await _databaseHelper.initDatabase();
    if (db != null) assessmentdb = await _databaseHelper.fetchData();
    for (int i = 0; i < assessmentdb.length; i++) {
      if (mode == 'Training Attendance' &&
          assessmentdb[i].type == 'training_attendance_pic_') {
        setState(() {
          _dbImages.add(assessmentdb[i].fileName);
        });
      }
    }
  }

  fetchVtpImage() async {
    db = await _databaseHelper.initDatabase();
    if (db != null) assessmentdb = await _databaseHelper.fetchData();
    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].fileName.contains('vtp_feedback_pic_$i') &&
          mode == 'VTP Feedback' &&
          assessmentdb[i].type == 'vtp_feedback_pic_')
        setState(() {
          _dbImages.add(assessmentdb[i].fileName);
        });
    }
  }

  fetchCocImage() async {
    db = await _databaseHelper.initDatabase();
    if (db != null) assessmentdb = await _databaseHelper.fetchData();
    for (int i = 0; i < assessmentdb.length; i++) {
      if (mode == 'Code of Conduct' &&
          assessmentdb[i].type == 'code_of_conduct_pic_')
        print('coc name: ${Path.basename(assessmentdb[i].fileName)}');
      setState(() {
        _dbImages.add(assessmentdb[i].fileName);
      });
    }
  }

  fetchPlacementImage() async {
    db = await _databaseHelper.initDatabase();
    if (db != null) assessmentdb = await _databaseHelper.fetchData();

    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].fileName.contains('placement_doc_pic_$i') &&
          mode == 'Placements Documents' &&
          assessmentdb[i].type == 'placement_doc_pic_') {
        setState(() {
          _dbImages.add(assessmentdb[i].fileName);
        });
      }
    }
  }

  fetchGroupImage() async {
    db = await _databaseHelper.initDatabase();
    if (db != null) assessmentdb = await _databaseHelper.fetchData();
    for (int i = 0; i < assessmentdb.length; i++) {
      if (mode == 'Group Photo' && assessmentdb[i].type == 'group_photo_') {
        setState(() {
          _dbImages.add(assessmentdb[i].fileName);
        });
      }
    }
  }

  Widget _buildSingleImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: _image == null || _dbImage.length == 0
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/img/placeholder.png',
                    fit: BoxFit.scaleDown,
                  ),
                )
              : _dbImage.length != 0 && _image == null
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.file(File(_dbImage)))
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.file(_image)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                ),
                onPressed: () => getCamImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                  child: Text(
                    'Finish',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
            )
          ],
        )
      ],
    );
  }

  Widget _buildMultiPic() {
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.builder(
            itemCount: _dbImages.length == 0 && _images.length == 0
                ? 6
                : _dbImages.length != null && _images.length == 0
                    ? _dbImages.length
                    : _images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 5.0, childAspectRatio: 0.9

                //mainAxisSpacing: 10.0
                ),
            itemBuilder: (context, int index) {
              return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _dbImages.length == 0 && _images.length == 0
                      ? Image.asset('assets/img/placeholder.png')
                      : _dbImages.length != null && _images.length == 0
                          ? Image.file(
                              File(_dbImages[index]),
                              fit: BoxFit.contain,
                            )
                          : Image.file(_images[index]));
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () => getCamImage(),
            ),
            FlatButton(
              child: Text('Finish'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Capture Image'),
      ),
      body: widget.index != 2 ? _buildMultiPic() : _buildSingleImage(),
    );
  }
}
