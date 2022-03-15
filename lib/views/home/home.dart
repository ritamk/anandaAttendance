import 'package:face_rec/services/auth/authentication.dart';
import 'package:face_rec/services/auth/database.dart';
import 'package:face_rec/shared/providers.dart';
import 'package:face_rec/views/authentication/auth_page.dart';
import 'package:face_rec/views/home/home_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.uid}) : super(key: key);
  final String? uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: <Widget>[
          Consumer(
            builder: (_, ref, __) => IconButton(
              onPressed: () async {
                await DatabaseService(
                        uid: ref.watch(userStreamProvider).value!.uid)
                    .verified(false);
                await AuthenticationService().signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(builder: (context) => const AuthPage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
      drawer: HomeDrawer(uid: uid),
    );
  }
}
