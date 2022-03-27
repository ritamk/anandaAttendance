import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_rec/models/attendance_model.dart';
import 'package:face_rec/services/database.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:face_rec/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({
    Key? key,
    required this.loc,
    required this.uid,
    required this.reporting,
  }) : super(key: key);
  final String uid;
  final GeoPoint loc;
  final bool reporting;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool loading = true;
  final LocalAuthentication localAuth = LocalAuthentication();
  bool? canCheckBiometric;
  bool attendanceDone = false;

  @override
  void initState() {
    super.initState();
    checkBiom();
    if (!mounted) {
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future checkBiom() async {
    try {
      canCheckBiometric = await localAuth.canCheckBiometrics.then((value) {
        setState(() {
          loading = false;
          value
              ? null
              : commonSnackbar(
                  "Required biometric services unavailable on device", context);
        });
        return;
      });
    } catch (e) {
      print("checkBiom: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Attendance"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: !loading
              ? !attendanceDone
                  ? MaterialButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          await localAuth
                              .authenticate(
                            localizedReason:
                                "Verify biometrics to mark attendance",
                            biometricOnly: true,
                          )
                              .then((value) {
                            if (value) {
                              DatabaseService(uid: widget.uid)
                                  .attendanceReporting(
                                EmpAttendanceModel(
                                  reporting: widget.reporting,
                                  time: Timestamp.now(),
                                  geoloc: widget.loc,
                                ),
                              )
                                  .whenComplete(() {
                                setState(() => attendanceDone = true);
                                commonSnackbar(
                                    "Attendance marked successfully", context);
                              }).onError((error, stackTrace) => commonSnackbar(
                                      "Failed to mark attendance, please try again",
                                      context));
                            } else {
                              commonSnackbar(
                                  "Biometric verification failed", context);
                            }
                          });
                        } on PlatformException catch (e) {
                          print("biometricFailed: ${e.toString()}");
                          commonSnackbar(
                              "Something went wrong, please try again\n"
                              "Error: ${e.toString()}",
                              context);
                        }
                        setState(() => loading = false);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              Icon(
                                Icons.fingerprint_outlined,
                                color: Colors.blue,
                                size: 32.0,
                              ),
                              Text(
                                " / ",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.blue,
                                ),
                              ),
                              Icon(
                                Icons.face,
                                color: Colors.blue,
                                size: 32.0,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0, width: 0.0),
                          const Text(
                            "Verify biometrics",
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade500,
                          size: 32.0,
                        ),
                        const SizedBox(height: 20.0, width: 0.0),
                        Text(
                          "Attendance marked",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.green.shade500,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
              : const Loading(white: false),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          clipBehavior: Clip.none,
        ),
      ),
    );
  }
}
