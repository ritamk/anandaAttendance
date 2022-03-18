import 'package:face_rec/models/employee_model.dart';
import 'package:face_rec/services/authentication.dart';
import 'package:face_rec/services/database.dart';
import 'package:face_rec/services/shared_pref.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:face_rec/views/attendance/att_report.dart';
import 'package:face_rec/views/authentication/auth_page.dart';
import 'package:face_rec/views/home/att_in_out_dialog.dart';
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
          LogginOutHome(uid: uid),
        ],
      ),
      body: FutureBuilder(
        future: DatabaseService(uid: uid).employeeDetail(),
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            detEmpModel = DetailedEmployeeModel(
              uid: snapshot.data["uid"],
              name: snapshot.data["name"],
              eID: snapshot.data["eID"],
              email: snapshot.data["email"],
              loc: snapshot.data["loc"],
            );
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        "Welcome,",
                        style: TextStyle(fontSize: 18.0, color: Colors.black54),
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
                  ),
                  const SizedBox(height: 20.0, width: 0.0),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0)),
                        subtitle: const Text("Record your attendance"),
                        trailing: const Icon(Icons.pan_tool_outlined,
                            color: Colors.white),
                        onTap: () =>
                            Navigator.of(context).push(CupertinoDialogRoute(
                          builder: (context) => AttendanceInOrOutDialog(
                              uid: uid!, loc: detEmpModel!.loc!),
                          context: context,
                        )),
                      ),
                      const SizedBox(height: 20.0, width: 0.0),
                      ListTile(
                        minVerticalPadding: 10.0,
                        tileColor: Colors.redAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        title: const Text("Attendance Summary",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0)),
                        subtitle: const Text("Your attendance records"),
                        trailing:
                            const Icon(Icons.date_range, color: Colors.white),
                        onTap: () => Navigator.of(context).push(
                            CupertinoPageRoute(
                                builder: (context) =>
                                    AttReportPage(uid: uid!))),
                      ),
                    ],
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18.0),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              clipBehavior: Clip.none,
            );
          } else {
            return const Center(child: Loading(white: false));
          }
        },
      ),
    );
  }
}

class LogginOutHome extends StatefulWidget {
  const LogginOutHome({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  State<LogginOutHome> createState() => _LogginOutHomeState();
}

class _LogginOutHomeState extends State<LogginOutHome> {
  bool loggingOut = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        setState(() => loggingOut = true);
        await AuthenticationService().signOut();
        await UserSharedPref.setVerifiedOrNot(false);
        await UserSharedPref.setUser("noUser");
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => const AuthPage()),
            (route) => false);
      },
      icon: !loggingOut
          ? const Icon(Icons.power_settings_new)
          : const Loading(white: false),
      tooltip: "Log-out",
    );
  }
}
