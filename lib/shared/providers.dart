// import 'package:face_rec/models/employee_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final firebaseAuthProvider =
//     Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// final userStreamProvider = StreamProvider<EmployeeModel?>((ref) {
//   try {
//     return ref.watch(firebaseAuthProvider).authStateChanges().map(
//         (User? user) => (user != null) ? EmployeeModel(uid: user.uid) : null);
//   } catch (e) {
//     print("userStreamProvider: ${e.toString()}");
//     return const Stream.empty();
//   }
// });
