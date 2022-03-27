// import 'package:camera/camera.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:face_rec/main.dart';
// import 'package:face_rec/shared/loading/loading.dart';
// import 'package:face_rec/shared/snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class OldAttendancePage extends StatefulWidget {
//   const OldAttendancePage({
//     Key? key,
//     required this.loc,
//     required this.uid,
//     required this.reporting,
//   }) : super(key: key);
//   final String uid;
//   final GeoPoint loc;
//   final bool reporting;

//   @override
//   State<OldAttendancePage> createState() => _OldAttendancePageState();
// }

// class _OldAttendancePageState extends State<OldAttendancePage> {
//   bool loading = true;
//   late CameraDescription frontCam;
//   late CameraController controller;
//   PermissionStatus? camPermissionStatus;
//   bool camPermission = false;

//   @override
//   void initState() {
//     super.initState();
//     camPermissions().then((value) => setState(() => camPermission = value));
//     frontCam = cameras.firstWhere((CameraDescription cameraDescription) =>
//         cameraDescription.lensDirection == CameraLensDirection.front);
//     try {
//       controller = CameraController(frontCam, ResolutionPreset.max);
//     } catch (e) {
//       print("camController: ${e.toString()}");
//       controller = CameraController(frontCam, ResolutionPreset.max);
//     }
//     try {
//       controller.initialize().then((value) {
//         if (!mounted) {
//           return;
//         }
//         setState(() => loading = false);
//       });
//     } catch (e) {
//       print("camControllerInit: ${e.toString()}");
//       controller
//           .initialize()
//           .then((value) => setState((() => loading = false)));
//     }
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   Future<bool> camPermissions() async {
//     camPermissionStatus = await Permission.camera.status;
//     switch (camPermissionStatus) {
//       case PermissionStatus.granted:
//         return true;
//       case PermissionStatus.denied:
//         setState(() => commonSnackbar(
//             "Camera and/or Microphone permissions denied", context));
//         return false;
//       case PermissionStatus.permanentlyDenied:
//         setState(() => commonSnackbar(
//             "Cannot request permission for camera and/or microphone", context));
//         return false;
//       default:
//         return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Face Recognition")),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(25.0),
//             ),
//             child: cameraLoadedWidget(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget cameraLoadedWidget() {
//     if (!loading) {
//       try {
//         return CameraPreview(controller);
//       } catch (e) {
//         print("cameraLoading: ${e.toString()}");
//         return CameraPreview(controller);
//       }
//     } else {
//       return const Loading(white: false);
//     }
//   }
// }
