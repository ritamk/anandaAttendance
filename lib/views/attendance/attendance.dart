import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({
    Key? key,
    required this.loc,
    required this.uid,
    required this.reporting,
  }) : super(key: key);
  final String uid;
  final GeoPoint loc;
  final bool reporting;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool loading = true;
  List<CameraDescription> cameras = <CameraDescription>[];
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    avlCameras();
  }

  void avlCameras() {
    availableCameras().then((value) {
      cameras = value;
      controller = CameraController(cameras[0], ResolutionPreset.max);
      controller.initialize();
    }).whenComplete(() => setState(() => loading = false));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Face Recognition")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: !loading
              ? CameraPreview(controller)
              : const Loading(white: false),
        ),
      ),
    );
  }
}
