import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

typedef RecordCallback = void Function(String);

class RecordButton extends StatefulWidget {
  const RecordButton({Key key, this.recordingFinishedCallback})
      : super(key: key);

  @override
  State<RecordButton> createState() => _RecordButtonState();

  final RecordCallback recordingFinishedCallback;
}

class _RecordButtonState extends State<RecordButton> {
  bool _isRecording = false;
  final _audioRecorder = Record();

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    final path = await _audioRecorder.stop();
    widget.recordingFinishedCallback(path);

    setState(() {
      _isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    if (_isRecording) {
      icon = Icons.stop;
      color = Color(0xffd36060);
    } else {
      icon = Icons.mic;
      color = Colors.grey[600];
    }
    return GestureDetector(
      onTap: () {
        _isRecording ? _stop() : _start();
      },
      child: Icon(
        icon,
        size: 30,
        color: color,
      ),
    );
  }
}
