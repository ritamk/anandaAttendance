import 'package:face_rec/services/database.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:face_rec/shared/providers.dart';
import 'package:face_rec/shared/snackbar.dart';
import 'package:face_rec/shared/text_field/auth_text_field.dart';
import 'package:face_rec/views/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EidConfirmDialog extends StatefulWidget {
  const EidConfirmDialog({Key? key}) : super(key: key);

  @override
  State<EidConfirmDialog> createState() => _EidConfirmDialogState();
}

class _EidConfirmDialogState extends State<EidConfirmDialog> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final FocusNode _eidNode = FocusNode();
  String eid = "";
  String originalEid = "";
  bool loading = false;
  String? user;

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
                        await DatabaseService(uid: user)
                            .eIDFromUID()
                            .then((value) {
                          originalEid = value ?? "";
                        }).whenComplete(() {
                          if (_globalKey.currentState!.validate()) {
                            if (eid.toUpperCase() == originalEid) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  CupertinoPageRoute(
                                    builder: (context) => HomePage(uid: user),
                                  ),
                                  (route) => false);
                              DatabaseService(uid: user).verified(true);
                            } else {
                              setState(() {
                                loading = false;
                                commonSnackbar(
                                    originalEid.isNotEmpty
                                        ? "Incorrect Employee ID"
                                        : "Something went wrong, please try again\nRe-check your credentials",
                                    context);
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
}
