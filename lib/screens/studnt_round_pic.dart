import 'dart:async';
import 'dart:io';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';

class StudentRoundPic extends StatefulWidget {
  final String studentCode;
  final Directory batchFolder;
  StudentRoundPic(this.studentCode, this.batchFolder);
  @override
  _StudentRoundPicState createState() => _StudentRoundPicState();
}

class _StudentRoundPicState extends State<StudentRoundPic> {
  File _profilePic;
  File _adharPic;

  Future<void> getCamImage(String mode) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 10);

    image.copy(
        '${widget.batchFolder.path}/${mode == 'adhar' ? 'aadhar_' + '${widget.studentCode}.png' : 'profile_' + '${widget.studentCode}.png'}');

    setState(() {
      if (image != null) {
        mode == 'adhar' ? _adharPic = image : _profilePic = image;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _profilePic == null
                      ? Image.asset(
                          'assets/img/placeholder.png',
                          height: 200.0,
                          width: 200.0,
                        )
                      : Image.file(
                          _profilePic,
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
                  _adharPic == null
                      ? Image.asset(
                          'assets/img/placeholder.png',
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
                child: Text('FINISH'),
                  onPressed: ()=>Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
