import 'package:face_rec/services/auth/authentication.dart';
import 'package:face_rec/services/auth/database.dart';
import 'package:face_rec/shared/loading/loading.dart';
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
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                child: snapshot.hasData
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text(
                            "Welcome,",
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.black45),
                            textAlign: TextAlign.start,
                          ),
                          Text(snapshot.data["name"],
                              style: const TextStyle(
                                  fontSize: 17.0, color: Colors.red)),
                          Text("(${snapshot.data["eID"]})",
                              style: const TextStyle(
                                  fontSize: 17.0, color: Colors.black45)),
                        ],
                      )
                    : const Loading(white: false),
              );
            },
          ),
          const SizedBox(height: 40.0, width: 0.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              ListTile(
                title: Text("Some title"),
              ),
              ListTile(
                title: Text("Another title"),
              ),
            ],
          ),
        ],
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(12.0),
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
      ),
    );
  }
}
