import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  final String uid;

  EmployeeModel({required this.uid});
}

class DetailedEmployeeModel {
  final String uid;
  final String name;
  final String eID;
  final String email;
  final bool verified;
  final GeoPoint? loc;

  DetailedEmployeeModel({
    required this.uid,
    required this.name,
    required this.eID,
    required this.verified,
    required this.email,
    required this.loc,
  });
}
