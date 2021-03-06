import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_rec/models/attendance_model.dart';
import 'package:face_rec/models/employee_model.dart';

final CollectionReference _employeeCollection =
    FirebaseFirestore.instance.collection("Employee");

final CollectionReference _empAttCollection =
    FirebaseFirestore.instance.collection("EmpAttendance");

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  Future setEmployeeData(DetailedEmployeeModel employee) async {
    try {
      String eid = employee.name.substring(0, 3).toUpperCase() +
          employee.uid.substring(0, 3).toUpperCase() +
          employee.uid.substring(15, 18).toUpperCase();
      try {
        await _empAttCollection.doc(uid).set({
          "attendance": {},
          "loc": employee.loc,
          "eID": eid,
        });
      } catch (e) {
        print("setEmpAttData: ${e.toString()}");
        return -2;
      }
      return await _employeeCollection.doc(uid).set({
        "uid": employee.uid,
        "name": employee.name,
        "email": employee.email,
        "eID": eid,
        "loc": employee.loc,
      });
    } catch (e) {
      print("setEmployeeData: ${e.toString()}");
      return -1;
    }
  }

  Future<String?> eIDFromUID() async {
    try {
      DocumentSnapshot doc = await _employeeCollection.doc(uid).get();
      return doc.get("eID");
    } catch (e) {
      print("eIDFromUID: ${e.toString()}");
      return null;
    }
  }

  Future employeeDetail() async {
    try {
      DocumentSnapshot snap = await _employeeCollection.doc(uid).get();
      return snap.data();
    } catch (e) {
      print("employeeDetail: ${e.toString()}");
      return null;
    }
  }

  Future<bool> updateGeoLocation(double lat, double lon) async {
    try {
      await _employeeCollection.doc(uid).update({
        "loc": GeoPoint(lat, lon),
      });
      return true;
    } catch (e) {
      print("updateGeoLocation: ${e.toString()}");
      return false;
    }
  }

  Future attendanceReporting(EmpAttendanceModel empAttendance) async {
    String date =
        empAttendance.time!.toDate().toString().substring(0, 10).trim();

    try {
      if (empAttendance.reporting!) {
        try {
          await _empAttCollection.doc(uid).update({
            "attendance.$date": FieldValue.arrayUnion([
              {
                "time": empAttendance.time,
                "reporting": true,
                "geoloc": empAttendance.geoloc,
              }
            ]),
          });
        } catch (e) {
          await _empAttCollection.doc(uid).update({
            "attendance": FieldValue.arrayUnion([
              {
                date: {
                  "time": empAttendance.time,
                  "reporting": true,
                  "geoloc": empAttendance.geoloc,
                }
              }
            ]),
          });
        }
      } else {
        try {
          await _empAttCollection.doc(uid).update({
            "attendance.$date": FieldValue.arrayUnion([
              {
                "time": empAttendance.time,
                "reporting": false,
                "geoloc": empAttendance.geoloc,
              }
            ]),
          });
        } catch (e) {
          await _empAttCollection.doc(uid).update({
            "attendance": FieldValue.arrayUnion([
              {
                date: {
                  "time": empAttendance.time,
                  "reporting": false,
                  "geoloc": empAttendance.geoloc,
                }
              }
            ]),
          });
        }
      }
    } catch (e) {
      print("attendanceReporting: ${e.toString}");
      return null;
    }
  }

  Future<List?> attendanceSummary(DateTime time) async {
    String date = time.toString().substring(0, 10);
    try {
      DocumentSnapshot snap = await _empAttCollection.doc(uid).get();

      return snap.get("attendance.$date");
    } catch (e) {
      print("attendanceSummary: ${e.toString()}");
      return List.empty();
    }
  }
}
