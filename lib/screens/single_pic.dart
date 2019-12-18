import 'dart:async';
import 'dart:io';
import 'package:assesment/screens/SelectBatch.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class SinglePic extends StatefulWidget {
  @override
  _SinglePicState createState() => _SinglePicState();
}

class _SinglePicState extends State<SinglePic> {
  File _image;
  Location location = Location();
  var latitude;
  var longitude;
  String _currentTime;

  Future<void> getCamImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
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
                      child: Stack(
                        children: <Widget>[
                          Image.file(_image),
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
                                  )
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
                  'Finish',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
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
