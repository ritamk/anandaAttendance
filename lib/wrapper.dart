import 'package:face_rec/services/database.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:face_rec/shared/providers.dart';
import 'package:face_rec/views/authentication/auth_page.dart';
import 'package:face_rec/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  String? user;

  @override
  Widget build(BuildContext context) {
    user = ref.watch(userStreamProvider).value?.uid;

    return user != null
        ? FutureBuilder<bool?>(
            future: DatabaseService(uid: user).verifiedOrNot(),
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data) {
                  return HomePage(uid: user);
                } else {
                  return const AuthPage();
                }
              } else {
                return const WrapperBody();
              }
            },
          )
        : const AuthPage();
  }
}

class WrapperBody extends StatelessWidget {
  const WrapperBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              "assets/images/anandamela_logo.png",
              colorBlendMode: BlendMode.overlay,
            ),
          ),
          const SizedBox(height: 40.0, width: 0.0),
          const Loading(white: false, rad: 14.0),
        ],
      ),
    );
  }
}
