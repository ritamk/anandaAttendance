import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_rec/models/employee_model.dart';

final CollectionReference _employeeCollection =
    FirebaseFirestore.instance.collection("Employee");

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  Future setEmployeeData(DetailedEmployeeModel employee) async {
    try {
      return await _employeeCollection.doc(uid).set({
        "uid": employee.uid,
        "name": employee.name,
        "email": employee.email,
        "eID": employee.name.substring(0, 3).toUpperCase() +
            employee.uid.substring(0, 3).toUpperCase() +
            employee.uid.substring(15, 18).toUpperCase(),
        "verified": employee.verified,
        "loc": employee.loc,
        "attendance": {},
      });
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future<EmployeeAuthModel> eIDAndLoc() async {
    try {
      DocumentSnapshot doc = await _employeeCollection.doc(uid).get();
      return EmployeeAuthModel(
        eid: doc.get("eID"),
        loc: doc.get("loc"),
      );
    } catch (e) {
      print("eIDAndLoc: ${e.toString()}");
      return EmployeeAuthModel(eid: "", loc: null);
    }
  }

  Future<bool> verifiedOrNot() async {
    try {
      DocumentSnapshot doc = await _employeeCollection.doc(uid).get();
      return await doc.get("verified");
    } catch (e) {
      print("verified: ${e.toString()}");
      return false;
    }
  }

  Future verified(bool yesOrNo) async {
    try {
      return await _employeeCollection.doc(uid).update({"verified": yesOrNo});
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future employeeDetail() async {
    try {
      DocumentSnapshot snap = await _employeeCollection.doc(uid).get();
      return snap.data();
    } catch (e) {
      print("employee: ${e.toString()}");
      return null;
    }
  }
}
