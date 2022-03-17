import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_rec/views/attendance/attendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendanceInOrOutDialog extends StatelessWidget {
  const AttendanceInOrOutDialog({
    Key? key,
    required this.uid,
    required this.loc,
  }) : super(key: key);
  final String uid;
  final GeoPoint loc;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Attendance type"),
      content: const Text("Are you reporting to your location or leaving?"),
      actions: <Widget>[
        CupertinoDialogAction(
          textStyle: const TextStyle(color: Colors.blue, fontSize: 16.0),
          child: const Text("In"),
          onPressed: () => toAttPage(context, true),
        ),
        CupertinoDialogAction(
          textStyle: const TextStyle(color: Colors.blue, fontSize: 16.0),
          child: const Text("Out"),
          onPressed: () => toAttPage(context, false),
        ),
      ],
    );
  }

  Future toAttPage(BuildContext context, bool reporting) {
    Navigator.pop(context);
    return Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) =>
            AttendancePage(uid: uid, loc: loc, reporting: reporting)));
  }
}
