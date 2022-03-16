import 'package:cloud_firestore/cloud_firestore.dart';

class EmpAttendanceModel {
  final Timestamp? time;
  final Timestamp? day;
  final String? inOrOut;

  EmpAttendanceModel({
    this.time,
    this.day,
    this.inOrOut,
  });
}
