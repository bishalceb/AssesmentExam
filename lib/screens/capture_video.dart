import 'dart:async';
import 'dart:io';

import 'package:assesment/database/assessmentdb.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class CaptureVideo extends StatefulWidget {
  final Directory batchFolder;
  final String mode;
  final String studentCode;
  final int visibleTheoryRound; //to shoot theory round video
  CaptureVideo(
      {this.batchFolder, this.mode, this.studentCode, this.visibleTheoryRound});
  @override
  _CaptureVideoState createState() => _CaptureVideoState();
}

class _CaptureVideoState extends State<CaptureVideo> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  initState() {
    super.initState();
    databaseHelper.initDatabase();
  }

  Future<void> getCamVideo() async {
    var video = await ImagePicker.pickVideo(source: ImageSource.camera);
    String getMode() {
      if (widget.mode == 'viva')
        return 'viva_${widget.studentCode}';
      else if (widget.mode == 'practical')
        return 'practical_${widget.studentCode}';
      else if (widget.mode == 'center infrastructure')
        return 'center_infra';
      else if (widget.mode == 'theory round')
        return 'theory_round_video_${widget.visibleTheoryRound}';
      else
        return '';
    }

    File copiedVideo =
        await video.copy('${widget.batchFolder.path}/${getMode()}.mp4');
    databaseHelper.insertData(AssessmentDb(
        fileName: copiedVideo.path,
        batchId: basename(widget.batchFolder.path),
        priority: 3,
        syncstatus: 0,
        type: getMode(),
        studentCode: ''));

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
