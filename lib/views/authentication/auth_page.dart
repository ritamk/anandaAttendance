import 'package:face_rec/shared/buttons/sign_in_bt.dart';
import 'package:face_rec/views/authentication/sign_in.dart';
import 'package:face_rec/views/authentication/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authentication"),
        centerTitle: true,
        // backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (builder) => const SignUpPage())),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                style: authSignInBtnStyle()),
            // const Padding(padding: EdgeInsets.all(16.0)),
            TextButton(
                onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                    builder: (builder) => const SignInPage())),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Log-in",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                style: authSignInBtnStyle()),
          ],
        ),
      ),
    );
  }
}
