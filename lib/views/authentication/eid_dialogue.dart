import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_rec/models/employee_model.dart';
import 'package:face_rec/services/auth/database.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:face_rec/shared/providers.dart';
import 'package:face_rec/shared/text_field/auth_text_field.dart';
import 'package:face_rec/views/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class EidConfirmDialog extends StatefulWidget {
  const EidConfirmDialog({Key? key}) : super(key: key);

  @override
  State<EidConfirmDialog> createState() => _EidConfirmDialogState();
}

class _EidConfirmDialogState extends State<EidConfirmDialog> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final FocusNode _eidNode = FocusNode();
  final coordVar = 0.0005;
  String eid = "";
  String originalEid = "";
  bool loading = false;
  String? user;
  EmployeeAuthModel? employeeAuth;
  Position? coord;
  GeoPoint? geoPointCoord;
  GeoPoint? desiredCoord;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Confirm your Employee-ID"),
      content: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(height: 20.0, width: 0.0),
                TextFormField(
                  decoration: authTextInputDecoration(
                      "Employee ID", Icons.badge_rounded),
                  validator: (val) =>
                      val!.isEmpty ? "Please enter your Employee ID" : null,
                  onChanged: (val) => eid = val,
                  textInputAction: TextInputAction.done,
                  focusNode: _eidNode,
                  onFieldSubmitted: (val) => FocusScope.of(context).unfocus(),
                ),
                const SizedBox(height: 20.0, width: 0.0),
                Consumer(
                  builder: (_, ref, __) {
                    user = ref.watch(userStreamProvider).value?.uid;
                    return CupertinoDialogAction(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: loading
                            ? const Loading(
                                white: false,
                              )
                            : const Text(
                                "Confirm",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 18.0),
                              ),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          coord = await _determinePosition();
                        } catch (e) {
                          setState(() {
                            loading = false;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          });
                        }
                        geoPointCoord =
                            GeoPoint(coord!.latitude, coord!.longitude);
                        await DatabaseService(uid: user)
                            .eIDAndLoc()
                            .then((value) {
                          originalEid = value.eid;
                          desiredCoord = value.loc;
                        }).whenComplete(() {
                          if (_globalKey.currentState!.validate()) {
                            if (eid.toUpperCase() == originalEid) {
                              if ((geoPointCoord!.latitude -
                                              desiredCoord!.latitude)
                                          .abs() <
                                      coordVar &&
                                  (geoPointCoord!.longitude -
                                              desiredCoord!.longitude)
                                          .abs() <
                                      coordVar) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    CupertinoPageRoute(
                                      builder: (context) => HomePage(uid: user),
                                    ),
                                    (route) => false);
                                DatabaseService(uid: user).verified(true);
                              } else {
                                setState(() {
                                  loading = false;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(originalEid.isNotEmpty
                                          ? "Incorrect Employee ID"
                                          : "Something went wrong, please try again"),
                                    ),
                                  );
                                });
                                DatabaseService(uid: user).verified(false);
                              }
                            } else {
                              setState(() {
                                loading = false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(originalEid.isNotEmpty
                                        ? "Incorrect credentials, please check"
                                        : "Something went wrong, please try again"),
                                  ),
                                );
                              });
                              DatabaseService(uid: user).verified(false);
                            }
                          }
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions');
    }

    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      return Geolocator.getLastKnownPosition();
    }
  }

  @override
  void dispose() {
    _eidNode.dispose();
    super.dispose();
  }
}
