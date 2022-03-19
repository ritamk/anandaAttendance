import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_rec/models/attendance_model.dart';
import 'package:face_rec/services/database.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:face_rec/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  bool loading = false;
  Position? coord;
  GeoPoint? geoPointCoord;
  GeoPoint? desiredCoord;
  final double coordVar = 0.0005;
  late bool biometricsAv;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: !loading
              ? Column(
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () async {
                        setState(() => loading = true);
                        try {
                          coord = await _determinePosition();
                          geoPointCoord =
                              GeoPoint(coord!.latitude, coord!.longitude);
                          desiredCoord = widget.loc;
                          if ((geoPointCoord!.latitude - desiredCoord!.latitude)
                                      .abs() <
                                  coordVar &&
                              (geoPointCoord!.longitude -
                                          desiredCoord!.longitude)
                                      .abs() <
                                  coordVar) {
                            DatabaseService(uid: widget.uid)
                                .attendanceReporting(EmpAttendanceModel(
                              geoloc: geoPointCoord,
                              time: Timestamp.now(),
                              reporting: widget.reporting,
                            ));
                            setState(() {
                              loading = false;
                              commonSnackbar(
                                  "Geolocation verification successful.",
                                  context);
                            });
                          } else {
                            setState(() {
                              loading = false;
                              commonSnackbar(
                                  "Geolocation verification failed.", context);
                            });
                          }
                        } catch (e) {
                          setState(() {
                            loading = false;
                            commonSnackbar(e.toString(), context);
                          });
                        }
                      },
                      child: Column(
                        children: const <Widget>[
                          Icon(Icons.location_on,
                              size: 24.0, color: Colors.blue),
                          SizedBox(height: 20.0, width: 0.0),
                          Text(
                            "Verify geolocation",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.blue),
                          ),
                        ],
                      ),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                  ],
                )
              : const Loading(white: false, rad: 14.0),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          clipBehavior: Clip.none,
        ),
      ),
    );
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Please enable location services.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Please allow location permissions.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Cannot request permissions, location permissions are permanently denied.');
    }

    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      return Geolocator.getLastKnownPosition();
    }
  }
}
