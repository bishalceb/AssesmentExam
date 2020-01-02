import 'dart:async';
import 'dart:io';
import 'package:assesment/database/assessmentdb.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:assesment/screens/SelectBatch.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
import 'package:sqflite/sqflite.dart';

class SinglePic extends StatefulWidget {
  @override
  _SinglePicState createState() => _SinglePicState();
}

class _SinglePicState extends State<SinglePic> {
  var directory;
  Directory createPath;
  Location location = Location();
  var latitude;
  var longitude;
  String _currentTime;
  File proctor_profile;
  String networkImageUrl;
  DatabaseHelper databaseHelper = DatabaseHelper();
  StorageReference _storageReference;
  List<AssessmentDb> assessmentdb = List<AssessmentDb>();
  Database db;
  String dbProctorProfile;

/*   void fetchData() async {
    Database initDb = await databaseHelper.initDatabase();
    if (initDb != null) assessmentdb = await databaseHelper.fetchData();
  } */
  @override
  initState() {
    super.initState();
    fetchImage();
  }

  Future<void> getCamImage() async {
    await Permission.requestPermissions(
        [PermissionName.Camera, PermissionName.Storage]);

    print(createPath.path.toString());

    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    File copiedImage;
    if (image != null)
      copiedImage = await image.copy('${createPath.path}/proctor_profile.png');

/*     FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://assessment-exam.appspot.com');

    String firebaseStoragePath = 'AssessmentExam/proctor_profile.png';

    StorageUploadTask uploadTask =
        _storage.ref().child(firebaseStoragePath).putFile(image);

    if (uploadTask.isComplete) {
      databaseHelper.updateData(AssessmentDb(
          fileName: basename(copiedImage.path),
          batchId: '',
          priority: 2,
          syncstatus: 1,
          type: 'proctor profile'));
    } */
    if (image == null) return;

    setState(() {
      if (image != null) {
        proctor_profile = image;
        _currentTime = DateFormat.jms().format(DateTime.now()).toString();
        databaseHelper.insertData(AssessmentDb(
          fileName: copiedImage.path,
          priority: 2,
          batchId: '',
          syncstatus: 0,
          type: 'proctor profile',
          studentCode: '',
        ));
      }
    });
  }

//load image from firebase
  loadImage() async {
    try {
      _storageReference =
          FirebaseStorage.instance.ref().child('Assessment/proctor_profile');

      if (_storageReference != null)
        await _storageReference.getDownloadURL().then((url) {
          networkImageUrl = url;
        });
      print('firebase url: $networkImageUrl');
    } catch (e) {
      print(e);
    }
  }

  fetchImage() async {
    db = await databaseHelper.initDatabase();
    if (db != null) assessmentdb = await databaseHelper.fetchData();

    for (int i = 0; i < assessmentdb.length; i++) {
      if (assessmentdb[i].type == 'proctor profile')
        setState(() {
          dbProctorProfile = assessmentdb[i].fileName;
        });
    }
    directory = await getExternalStorageDirectory();
    createPath =
        await Directory('${directory.path}/Assesment').create(recursive: true);
  }

  Future<LocationData> getLocation() async {
    try {
      var _currentLocation = await location.getLocation();

      setState(() {
        longitude = _currentLocation.longitude;
        latitude = _currentLocation.latitude;
      });

      return _currentLocation;
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    //fetchImage();
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: <Widget>[
                  dbProctorProfile == null && proctor_profile == null
                      ? Image.asset('assets/img/placeholder.png')
                      : dbProctorProfile != null && proctor_profile == null
                          ? Image.file(File(dbProctorProfile))
                          : Image.file(proctor_profile),
                  Positioned(
                    bottom: 50.0,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'current Time: $_currentTime',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'latitude: $latitude',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'longitude: $longitude',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                    ),
                    onPressed: () {
                      getLocation();
                      getCamImage();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      //if (proctor_profile != null)
                      //print('filename: ${assessmentdb[0].fileName}');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectBatch(createPath)));
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
