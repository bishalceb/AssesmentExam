import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CaptureVideo extends StatefulWidget {
  @override
  _CaptureVideoState createState() => _CaptureVideoState();
}

class _CaptureVideoState extends State<CaptureVideo> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  Future<void> getCamVideo() async {
    var video = await ImagePicker.pickVideo(source: ImageSource.camera);
    setState(() {
      if (video != null)
        _videoPlayerController = VideoPlayerController.file(video);
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _videoPlayerController == null
                  ? Image.asset('assets/img/video_player.png')
                  : Chewie(
                      controller: ChewieController(
                          aspectRatio: 3 / 2,
                          autoPlay: true,
                          allowFullScreen: true,
                          allowMuting: true,
                          videoPlayerController: _videoPlayerController),
                    ),
              FlatButton.icon(
                icon: Icon(Icons.videocam),
                label: Text('Capture Video'),
                onPressed: getCamVideo,
              ),
              RaisedButton(
                child: Text('NEXT'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
