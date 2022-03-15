import 'package:face_rec/services/auth/database.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key, required this.uid}) : super(key: key);

  final String? uid;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(4.0),
        children: <Widget>[
          FutureBuilder(
            future: DatabaseService(uid: uid).employeeDetail(),
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return DrawerHeader(
                child: snapshot.hasData
                    ? RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black45),
                          children: <InlineSpan>[
                            const TextSpan(text: "Name: "),
                            TextSpan(
                              text: "${snapshot.data["name"]}\n",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: "E-ID: "),
                            TextSpan(
                              text: "${snapshot.data["eID"]}",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : const Loading(white: false),
              );
            },
          ),
        ],
      ),
    );
  }
}
