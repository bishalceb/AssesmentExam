import 'dart:async';
import 'dart:io';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:assesment/database/assessmentdb.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CaptureImage extends StatefulWidget {
  final int index;
  final String mode;
  final StudentData student;
  final Directory batchFolder;
  CaptureImage({this.index, this.mode, this.student, this.batchFolder});
  @override
  _CaptureImageState createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {
  @override
  initState() {
    _databaseHelper.initDatabase();
    super.initState();
  }

  DatabaseHelper _databaseHelper = DatabaseHelper();
  File _image;
  List<File> _images = [];
  String imageName;

  Future<void> getCamImage() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 10);

    if (image == null) return;
    setState(() {
      if (image != null)
        widget.index == 2 ? _image = image : _images.add(image);
    });
    if (_image != null || _images != null) {
      if (widget.mode == 'candidate') {
        File copiedImagePath = await _image.copy(
            '${widget.batchFolder.path}/candidate_${widget.student.studentCode}.png');
        _databaseHelper.insertData(AssessmentDb(
            fileName: copiedImagePath.path,
            batchId: basename(widget.batchFolder.path),
            priority: 1,
            syncstatus: 0,
            type: 'candidate',
            studentCode: widget.student.studentCode));
      } else if (widget.mode == 'Exam Attendance') {
        for (int i = 0; i < _images.length; i++) {
          File copiedImagePath = await _images[i].copy(
              '${widget.batchFolder.path}/exam_attendance_pic_${i + 1}.png');
          _databaseHelper.insertData(AssessmentDb(
              fileName: copiedImagePath.path,
              batchId: basename(widget.batchFolder.path),
              priority: 1,
              syncstatus: 0,
              type: 'exam_attendance_pic_',
              studentCode: ''));
        }
      } else if (widget.mode == 'Assessor Feedback') {
        for (int i = 0; i < _images.length; i++) {
          File copiedImagePath = await _images[i]
              .copy('${widget.batchFolder.path}/assessor_feedback_pic_${i + 1}.png');
          _databaseHelper.insertData(AssessmentDb(
              fileName: copiedImagePath.path,
              batchId: basename(widget.batchFolder.path),
              priority: 1,
              syncstatus: 0,
              type: 'assessor_feedback_pic_',
              studentCode: ''));
        }
      } else if (widget.mode == 'Training Attendance') {
        for (int i = 0; i < _images.length; i++) {
          File copiedImagePath = await _images[i].copy(
              '${widget.batchFolder.path}/training_attendance_pic_${i + 1}.png');

          _databaseHelper.insertData(AssessmentDb(
              fileName: copiedImagePath.path,
              batchId: basename(widget.batchFolder.path),
              priority: 1,
              syncstatus: 0,
              type: 'training_attendance_pic_',
              studentCode: ''));
        }
      } else if (widget.mode == 'VTP Feedback') {
        for (int i = 0; i < _images.length; i++) {
          File copiedImagePath = await _images[i]
              .copy('${widget.batchFolder.path}/vtp_feedback_pic_${i + 1}.png');

          _databaseHelper.insertData(AssessmentDb(
              fileName: copiedImagePath.path,
              batchId: basename(widget.batchFolder.path),
              priority: 1,
              syncstatus: 0,
              type: 'vtp_feedback_pic_',
              studentCode: ''));
        }
      } else if (widget.mode == 'Code of Conduct') {
        for (int i = 0; i < _images.length; i++) {
          File copiedImagePath = await _images[i]
              .copy('${widget.batchFolder.path}/code_of_conduct_pic_${i + 1}.png');
          _databaseHelper.insertData(AssessmentDb(
              fileName: copiedImagePath.path,
              batchId: basename(widget.batchFolder.path),
              priority: 1,
              syncstatus: 0,
              type: 'code_of_conduct_pic_',
              studentCode: ''));
        }
      } else if (widget.mode == 'Placements Documents') {
        for (int i = 0; i < _images.length; i++) {
          File copiedImagePath = await _images[i]
              .copy('${widget.batchFolder.path}/placement_doc_pic_${i + 1}.png');

          _databaseHelper.insertData(AssessmentDb(
              fileName: copiedImagePath.path,
              batchId: basename(widget.batchFolder.path),
              priority: 1,
              syncstatus: 0,
              type: 'placement_doc_pic_',
              studentCode: ''));
        }
      } else if (widget.mode == 'Group Photo') {
        for (int i = 0; i < _images.length; i++) {
          File copiedImagePath = await _images[i]
              .copy('${widget.batchFolder.path}/group_photo_${i + 1}.png');
          _databaseHelper.insertData(AssessmentDb(
              fileName: copiedImagePath.path,
              batchId: basename(widget.batchFolder.path),
              priority: 1,
              syncstatus: 0,
              type: 'group_photo_',
              studentCode: ''));
        }
      }
    }
  }

  Widget _buildSingleImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: _image == null
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/img/placeholder.png',
                    fit: BoxFit.scaleDown,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.file(_image),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            icon: Icon(
              Icons.camera_alt,
              size: 50.0,
            ),
            onPressed: () => getCamImage(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: RaisedButton(
            child: Text(
              'Finish',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              //Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  Widget _buildMultiPic() {
    return Column(
      children: <Widget>[
        Expanded(
          child: GridView.builder(
            itemCount: _images.length <= 0 ? 6 : _images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 5.0, childAspectRatio: 0.9

                //mainAxisSpacing: 10.0
                ),
            itemBuilder: (context, int index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: _images.length <= 0
                    ? Image.asset('assets/img/placeholder.png')
                    : Image.file(
                        _images[index],
                        fit: BoxFit.contain,
                      ),
              );
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
              onPressed: () {},
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
