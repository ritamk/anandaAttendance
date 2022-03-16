import 'package:face_rec/models/employee_model.dart';
import 'package:face_rec/services/auth/authentication.dart';
import 'package:face_rec/services/auth/database.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:face_rec/views/authentication/auth_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  Widget build(BuildContext context) {
    DetailedEmployeeModel? detEmpModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await DatabaseService(uid: uid).verified(false);
              await AuthenticationService().signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) => const AuthPage()),
                  (route) => false);
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: "Log-out",
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            future: DatabaseService(uid: uid).employeeDetail(),
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                detEmpModel = DetailedEmployeeModel(
                  uid: snapshot.data["uid"],
                  name: snapshot.data["name"],
                  eID: snapshot.data["eID"],
                  verified: snapshot.data["verified"],
                  email: snapshot.data["email"],
                  loc: snapshot.data["loc"],
                );
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          "Welcome,",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black54),
                          textAlign: TextAlign.start,
                        ),
                        Text(detEmpModel!.name,
                            style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                        Text("(E-ID: ${detEmpModel!.eID})",
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.black54)),
                      ],
                    ));
              } else {
                return const Loading(white: false);
              }
            },
          ),
          const SizedBox(height: 40.0, width: 0.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                minVerticalPadding: 10.0,
                tileColor: Colors.redAccent,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                title: const Text("Attendance Recorder",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                subtitle: const Text("Record your attendance"),
                trailing:
                    const Icon(Icons.pan_tool_outlined, color: Colors.white),
              ),
              const SizedBox(height: 20.0, width: 0.0),
              ListTile(
                minVerticalPadding: 10.0,
                tileColor: Colors.redAccent,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                title: const Text("Attendance Summary",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                subtitle: const Text("Your attendance records"),
                trailing: const Icon(Icons.date_range, color: Colors.white),
              ),
            ],
          ),
        ],
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(12.0),
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        // clipBehavior: Clip.none,
      ),
    );
  }
}
