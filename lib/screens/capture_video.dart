import 'dart:async';
import 'dart:io';

import 'package:assesment/database/assessmentdb.dart';
import 'package:assesment/database/databasehelper.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import 'package:video_player/video_player.dart';
import '../database/assessmentdb.dart';

class CaptureVideo extends StatefulWidget {
  final Directory batchFolder;
  final String mode;
  final String studentCode;
  final int visibleTheoryRound;
  //to shoot theory round video
  CaptureVideo(
      {this.batchFolder, this.mode, this.studentCode, this.visibleTheoryRound});
  @override
  _CaptureVideoState createState() => _CaptureVideoState();
}

class _CaptureVideoState extends State<CaptureVideo> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  DatabaseHelper databaseHelper = DatabaseHelper();
  Database db;
  String dbVideo;

  List<AssessmentDb> assessmentdb = List<AssessmentDb>();
  @override
  initState() {
    super.initState();
    //databaseHelper.initDatabase();
    fetchVideo();
  }

  Future<void> getCamVideo(String camMode) async {
    var video;
    if (camMode == 'camera')
      video = await ImagePicker.pickVideo(source: ImageSource.camera);
    else
      video = await ImagePicker.pickVideo(source: ImageSource.gallery);
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

    if (video != null) {
      File copiedVideo =
          await video.copy('${widget.batchFolder.path}/${getMode()}.mp4');
      databaseHelper.insertData(AssessmentDb(
          fileName: copiedVideo.path,
          batchId: Path.basename(widget.batchFolder.path),
          priority: 3,
          syncstatus: 0,
          type: getMode(),
          studentCode: ''));
    }
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

  fetchVideo() async {
    db = await databaseHelper.initDatabase();
    if (db != null) assessmentdb = await databaseHelper.fetchData();

    for (int i = 0; i < assessmentdb.length; i++) {
      if (widget.mode == 'viva' &&
          assessmentdb[i].fileName.contains('viva_${widget.studentCode}') &&
          Path.basename(widget.batchFolder.path) == assessmentdb[i].batchId)
        setState(() {
          _videoPlayerController =
              VideoPlayerController.file(File(assessmentdb[i].fileName));
        });

      if (widget.mode == 'practical' &&
          assessmentdb[i]
              .fileName
              .contains('practical_${widget.studentCode}') &&
          Path.basename(widget.batchFolder.path) == assessmentdb[i].batchId)
        setState(() {
          _videoPlayerController =
              VideoPlayerController.file(File(assessmentdb[i].fileName));
        });

      if (widget.mode == 'center infrastructure' &&
          assessmentdb[i].fileName.contains('center_infra') &&
          Path.basename(widget.batchFolder.path) == assessmentdb[i].batchId)
        setState(() {
          _videoPlayerController =
              VideoPlayerController.file(File(assessmentdb[i].fileName));
        });

      if (widget.mode == 'theory round' &&
          assessmentdb[i]
              .fileName
              .contains('theory_round_video_${widget.visibleTheoryRound}') &&
          Path.basename(widget.batchFolder.path) == assessmentdb[i].batchId)
        setState(() {
          _videoPlayerController =
              VideoPlayerController.file(File(assessmentdb[i].fileName));
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: <Widget>[
            InkWell(
              onTap:()=> getCamVideo('camera'),
              //child: Expanded(
                child: _videoPlayerController == null
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/img/video_player.png'),
                )
                    : Chewie(
                  controller: ChewieController(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      autoPlay: true,
                      allowFullScreen: true,
                      allowMuting: true,
                      videoPlayerController: _videoPlayerController),
                ),
              //),
            ),
            Spacer(
              flex: 1,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                   Expanded(
                    child: FlatButton.icon(
                      icon: Icon(Icons.videocam),
                      label: Text('Capture Video',maxLines: 4,),
                      onPressed: () => getCamVideo('camera'),
                    ),
                  ),
                Expanded(
                    child:FlatButton.icon(
                      icon: Icon(Icons.video_library),
                      label: Text('Browse Video',maxLines: 2),
                      onPressed: () => getCamVideo('gallery'),
                    ),
                ),
                Expanded(
                  child: FlatButton(
                    child: Text('NEXT'),
                    onPressed: () {
                      Navigator.pop(context);
                       }
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
