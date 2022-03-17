import 'package:cloud_firestore/cloud_firestore.dart';

class EmpAttendanceModel {
  final Timestamp? time;
  final bool? reporting;
  final GeoPoint? geoloc;
  final String? eID;

  EmpAttendanceModel({
    this.time,
    this.reporting,
    this.geoloc,
    this.eID,
  });
}
