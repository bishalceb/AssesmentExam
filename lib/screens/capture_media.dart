import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as prefix0;
import 'package:multi_media_picker/multi_media_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class CaptureMedia extends StatefulWidget {
  final int index;
  final String appBarTitle;
  CaptureMedia(this.index, this.appBarTitle);
  @override
  _CaptureMediaState createState() => _CaptureMediaState(index, appBarTitle);
}

class _CaptureMediaState extends State<CaptureMedia> {
  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
  }

  final int index;
  final String appBartitle;

  _CaptureMediaState(this.index, this.appBartitle);
  List<File> _images = List<File>();
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  static int _currentIndex = 0;
  static const List<String> _popupmenuItems = ['Camera', 'Gallery'];
  static String _selectedPopupMenuItem;

  Widget _buildVideoPicker() {
    return _videoPlayerController == null
        ? Center(
            child: Text(
            'Import video',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ))
        : Chewie(
            controller: ChewieController(
                aspectRatio: 3 / 2,
                autoPlay: true,
                allowFullScreen: true,
                allowMuting: true,
                videoPlayerController: _videoPlayerController),
          );
  }

  Widget _buildImageGridView() {
    return _images.length <= 0
        ? Center(
            child: Text(
            'Import pictures',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ))
        : GridView.builder(
            padding: EdgeInsets.all(1.0),
            shrinkWrap: true,
            itemCount: _images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 0.8),
            itemBuilder: (context, int index) {
              return Image.file(
                _images[index],
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              );
            },
          );
  }

  Future<void> getImages(ImageSource source, bool singleImage) async {
    try {
      List<File> images = await MultiMediaPicker.pickImages(
          maxHeight: 100.0,
          maxWidth: 100.0,
          source: source,
          singleImage: singleImage);
      setState(() {
        if (images != null) {
          _images.addAll(images);
        }
      });
    } on Exception catch (e) {
      print('exception: ' + e.toString());
    }
  }

  Future<void> getCamImage() async {
    var image =
        await prefix0.ImagePicker.pickImage(source: prefix0.ImageSource.camera);
    if (image == null) return;
    final String path = getApplicationDocumentsDirectory().toString();
    print('image path: $path');
    var fileName = basename(image.path);
    final File localImage = await image.copy('$path/$fileName');
    setState(() {
      if (image != null) _images.add(image);
    });
  }

  Future<void> getCamVideo(prefix0.ImageSource source) async {
    var video = await prefix0.ImagePicker.pickVideo(source: source);
    setState(() {
      if (video != null)
        _videoPlayerController = VideoPlayerController.file(video);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBartitle),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (item) {
                _selectedPopupMenuItem = item;
                if (_selectedPopupMenuItem == 'Camera' && _currentIndex == 1)
                  getCamImage();
                if (_selectedPopupMenuItem == 'Camera' && _currentIndex == 0)
                  getCamVideo(prefix0.ImageSource.camera);
                if (_selectedPopupMenuItem == 'Gallery' && _currentIndex == 1)
                  getImages(ImageSource.gallery, false);
                if (_selectedPopupMenuItem == 'Gallery' && _currentIndex == 0)
                  getCamVideo(prefix0.ImageSource.gallery);
              },
              itemBuilder: (context) {
                return _popupmenuItems
                    .map((item) => PopupMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList();
              },
            )
          ],
        ),
        body: _currentIndex == 0 ? _buildVideoPicker() : _buildImageGridView(),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.videocam), title: Text('Video')),
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_camera), title: Text('Picture'))
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(false);
      },
    );
  }
}
