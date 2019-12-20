import 'dart:async';
import 'dart:io';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  File _image;
  List<File> _images = [];
  String imageName;

  Future<void> getCamImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image == null) return;
    setState(() {
      if (image != null)
        widget.index == 2 ? _image = image : _images.add(image);
    });
    if (_image != null || _images != null) {
      if (widget.mode == 'candidate')
        _image.copy('candidate_${widget.student.studentCode}.png');
      else if (widget.mode == 'Exam Attendance') {
        for (int i = 0; i < _images.length; i++) {
          await _images[i]
              .copy('${widget.batchFolder}/exam_attendance_pic_${i + 1}.png');
        }
      }
    }
  }

/*   Future<void> getCamImages() async { //taking pic with multimediapicker not working
    try {
      List<File> images = await MultiMediaPicker.pickImages(
        maxHeight: 100.0,
        maxWidth: 100.0,
        source: ImageSource.camera,
      );
      setState(() {
        if (images != null) {
          _images.addAll(images);
        }
      });
    } on Exception catch (e) {
      print('exception: ' + e.toString());
    }
  } */

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
              getCamImage();
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
