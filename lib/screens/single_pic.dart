import 'dart:async';
import 'dart:io';
import 'package:assesment/screens/SelectBatch.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';

class SinglePic extends StatefulWidget {
  @override
  _SinglePicState createState() => _SinglePicState();
}

class _SinglePicState extends State<SinglePic> {
  var directory;
  File _image;
  Location location = Location();
  var latitude;
  var longitude;
  String _currentTime;
  File proctor_profile;

  Future<void> getCamImage() async {
    await Permission.requestPermissions(
        [PermissionName.Camera, PermissionName.Storage]);

    directory = await getExternalStorageDirectory();
    var createPath =
        await Directory('${directory.path}/Assesment').create(recursive: true);
    print(createPath.path.toString());

    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    proctor_profile =
        await image.copy('${createPath.path}/proctor_profile.png');
    //image.copy('${createPath.path}/')
    /*final String path = getApplicationDocumentsDirectory().toString();
    print('image path: $path');
    var fileName = basename(image.path);
    final File localImage = await image.copy('$path/$fileName'); */
    setState(() {
      if (image != null) _image = image;
      _currentTime = DateFormat.jms().format(DateTime.now()).toString();
    });
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
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: proctor_profile == null
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/img/placeholder.png',
                        fit: BoxFit.scaleDown,
                      ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _currentTime,
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
                    ),
            ),
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
                  if (_image != null)
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SelectBatch()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
