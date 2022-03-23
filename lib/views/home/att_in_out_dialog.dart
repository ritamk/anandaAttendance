import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:face_rec/shared/snackbar.dart';
import 'package:face_rec/views/attendance/attendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceInOrOutDialog extends StatefulWidget {
  const AttendanceInOrOutDialog({
    Key? key,
    required this.uid,
    required this.loc,
  }) : super(key: key);
  final String uid;
  final GeoPoint loc;

  @override
  State<AttendanceInOrOutDialog> createState() =>
      _AttendanceInOrOutDialogState();
}

class _AttendanceInOrOutDialogState extends State<AttendanceInOrOutDialog> {
  bool loading = false;
  Position? coord;
  GeoPoint? geoPointCoord;
  GeoPoint? desiredCoord;
  final double coordVar = 0.0005;
  bool verified = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Verify geolocation"),
      content: Column(
        children: <Widget>[
          !loading
              ? MaterialButton(
                  child: const Icon(Icons.location_on,
                      size: 24.0, color: Colors.blue),
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
                          (geoPointCoord!.longitude - desiredCoord!.longitude)
                                  .abs() <
                              coordVar) {
                        setState(() {
                          loading = false;
                          commonSnackbar(
                              "Geolocation verification successful.", context);
                          verified = true;
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
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                )
              : const Loading(white: false),
          const Text("Are you entering (In) or leaving (Out) the location?"),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          textStyle: const TextStyle(color: Colors.blue, fontSize: 16.0),
          child: const Text("In"),
          onPressed: () => verified
              ? toAttPage(context, true)
              : commonSnackbar("Geolocation not verified", context),
        ),
        CupertinoDialogAction(
          textStyle: const TextStyle(color: Colors.blue, fontSize: 16.0),
          child: const Text("Out"),
          onPressed: () => verified
              ? toAttPage(context, false)
              : commonSnackbar("Geolocation not verified", context),
        ),
      ],
    );
  }

  Future toAttPage(BuildContext context, bool reporting) {
    Navigator.pop(context);
    return Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => AttendancePage(
            uid: widget.uid, loc: widget.loc, reporting: reporting)));
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
