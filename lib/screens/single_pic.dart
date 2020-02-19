import 'dart:async';
import 'dart:io';
import 'package:assesment/database/assessmentdb.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:assesment/screens/SelectBatch.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
import 'package:assesment/api/UserDetailApi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:device_info/device_info.dart';

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
  String proctor_id;
  String dbProctorProfile;
  static String device_name;

/*   void fetchData() async {
    Database initDb = await databaseHelper.initDatabase();
    if (initDb != null) assessmentdb = await databaseHelper.fetchData();
  } */
  @override
  initState() {
    super.initState();
    proctor_id=UserDetailApi.response[0].id;
    getDeviceDetails();
    getLocation();
    fetchImage();
  }

  Future<void> getCamImage() async {
    await Permission.requestPermissions(
        [PermissionName.Camera, PermissionName.Storage]);

    print(createPath.path.toString());

    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 1);
    File copiedImage;
    if (image != null)
      copiedImage = await image.copy('${createPath.path}/proctor_profile_${proctor_id}_${device_name}.png');

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
          mainAxisSize: MainAxisSize.max,
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
                      bottom: 10.0,
                      child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: 500,
                                        height: 30,
                                        color:Colors.blue,
                                          child: Text(
                                            '  Current Time: $_currentTime',
                                            style: TextStyle(
                                                fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white),
                                          ),
                                    ),
                                  ],
                                )
                              ),
                                Padding(
                                padding: const EdgeInsets.all(10.0),
                              child:Container(
                                width: 500,
                                height: 30,
                                color:Colors.blue,
                                child: Text(
                                  '  Latitude: $latitude',
                                  style: TextStyle(
                                      fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              )
                                ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  width: 500,
                                  color:Colors.blue,
                                  child: Text(
                                    '  Longitude: $longitude',
                                    style: TextStyle(
                                        fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ),
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
                      //getLocation();
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
                              builder: (context) => SelectBatch(createPath,longitude,latitude)));
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
  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.androidId;
        deviceVersion = build.version.toString();
        device_name=deviceName;
        UserDetailApi.response[0].deviceId=deviceName;
        print("device name"+deviceName);
        return [deviceName, deviceVersion, identifier];
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;//UUID for iOS
        device_name=deviceName;
        return [deviceName, deviceVersion, identifier];
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

  }
}
