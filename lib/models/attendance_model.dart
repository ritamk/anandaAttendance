import 'package:cloud_firestore/cloud_firestore.dart';

class EmpAttendanceModel {
  final Timestamp? time;
  final Timestamp? day;
  final bool? reporting;

  EmpAttendanceModel({
    this.time,
    this.day,
    this.reporting,
  });
}
