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
  AssessmentDb assessmentDb;
  StorageReference _storageReference;
  List<AssessmentDb> assessmentdb = List<AssessmentDb>();

/*   void fetchData() async {
    Database initDb = await databaseHelper.initDatabase();
    if (initDb != null) assessmentdb = await databaseHelper.fetchData();
  } */

  Future<void> getCamImage() async {
    await Permission.requestPermissions(
        [PermissionName.Camera, PermissionName.Storage]);

    directory = await getExternalStorageDirectory();
    createPath =
        await Directory('${directory.path}/Assesment').create(recursive: true);

    print(createPath.path.toString());

    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    File copiedImage =
        await image.copy('${createPath.path}/proctor_profile.png');

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
            studentCode: ''));
      }
    });
  }

//load image from firebase
  loadImage() async {
    try {
      _storageReference =
          FirebaseStorage.instance.ref().child('AssessmentExam/proctor_image');

      if (_storageReference != null)
        await _storageReference.getDownloadURL().then((url) {
          networkImageUrl = url;
        });
      print('firebase url: $networkImageUrl');
    } catch (e) {
      print(e);
    }
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
    //fetchData();
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: networkImageUrl == null
                    ? proctor_profile == null
                        ? Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset('assets/img/placeholder.png'),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              children: <Widget>[
                                Image.file(proctor_profile),
                                Positioned(
                                  bottom: 0.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'current Time: $_currentTime',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'latitude: $latitude',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'longitude: $longitude',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                    : FadeInImage(
                        image: NetworkImage(networkImageUrl),
                        placeholder: AssetImage('assets/img/loading.gif'),
                      )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  size: 50.0,
                ),
                onPressed: () {
                  getLocation();
                  getCamImage();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
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
            )
          ],
        ),
      ),
    );
  }
}
