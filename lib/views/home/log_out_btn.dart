import 'package:face_rec/services/authentication.dart';
import 'package:face_rec/services/shared_pref.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:face_rec/views/authentication/auth_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
