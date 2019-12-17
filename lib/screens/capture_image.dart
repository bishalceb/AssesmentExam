import 'dart:async';
import 'dart:io';
import 'package:assesment/style/theme.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as prefix0;
import 'package:multi_media_picker/multi_media_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CaptureImage extends StatefulWidget {
  final int index;
  CaptureImage(this.index);
  @override
  _CaptureImageState createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {
  File _image;
  List<File> _images = [];

  Future<void> getCamImage() async {
    var image =
        await prefix0.ImagePicker.pickImage(source: prefix0.ImageSource.camera);
    if (image == null) return;
    /*final String path = getApplicationDocumentsDirectory().toString();
    print('image path: $path');
    var fileName = basename(image.path);
    final File localImage = await image.copy('$path/$fileName'); */
    setState(() {
      if (image != null)
        widget.index == 2 ? _image = image : _images.add(image);
    });
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
