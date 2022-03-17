import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_rec/models/employee_model.dart';
import 'package:face_rec/services/auth/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  EmployeeModel? _employeefromFB(User? user) {
    return (user != null) ? EmployeeModel(uid: user.uid) : null;
  }

  Future signInWithMailPass(String mail, String pass) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: mail, password: pass);

      return _employeefromFB(userCredential.user);
    } catch (e) {
      print("signInWithMailPass: ${e.toString()}");
      return -1;
    }
  }

  Future registerWithMailPass(String name, String mail, String pass) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: mail, password: pass);
      User? user = userCredential.user;

      await DatabaseService(uid: user!.uid)
          .setEmployeeData(DetailedEmployeeModel(
        uid: user.uid,
        name: name,
        email: mail,
        eID: "",
        verified: true,
        loc: const GeoPoint(23.259086, 87.871203),
      ));

      return _employeefromFB(user)?.uid;
    } catch (e) {
      print("registerWithMailPass: ${e.toString()}");
      return -1;
    }
  }

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print("signOut: ${e.toString()}");
      return -1;
    }
  }

  Future<String?> currentUser() async {
    return _firebaseAuth.currentUser?.uid;
  }
}
