import 'package:face_rec/services/auth/authentication.dart';
import 'package:face_rec/shared/buttons/sign_in_bt.dart';
import 'package:face_rec/shared/loading/loading.dart';
import 'package:face_rec/shared/text_field/auth_text_field.dart';
import 'package:face_rec/views/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String name = "";
  String mail = "";
  String pass = "";
  bool _hidePassword = true;
  bool loading = false;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _mailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _globalKey,
            child: Column(
              children: <Widget>[
                // name form field
                TextFormField(
                  decoration: authTextInputDecoration("Name", Icons.person),
                  focusNode: _nameFocusNode,
                  validator: (val) =>
                      val!.isEmpty ? "Please enter your name" : null,
                  onChanged: (val) => name = val,
                  maxLength: 20,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (val) =>
                      FocusScope.of(context).requestFocus(_mailFocusNode),
                ),
                const SizedBox(
                  height: 20.0,
                  width: 0.0,
                ),
                // Email form field
                TextFormField(
                  decoration: authTextInputDecoration("Email", Icons.mail),
                  focusNode: _mailFocusNode,
                  validator: (val) =>
                      val!.isEmpty ? "Please enter a valid email" : null,
                  onChanged: (val) => mail = val,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (val) =>
                      FocusScope.of(context).requestFocus(_passFocusNode),
                ),
                const SizedBox(
                  height: 20.0,
                  width: 0.0,
                ),
                // Password form field
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    prefixIcon: const Icon(Icons.vpn_key),
                    labelText: "Password",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: textFieldBorder(),
                    focusedBorder: textFieldBorder(),
                    errorBorder: textFieldBorder(),
                    suffixIcon: IconButton(
                        onPressed: () => setState(
                              () => _hidePassword = !_hidePassword,
                            ),
                        icon: (_hidePassword)
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off)),
                  ),
                  focusNode: _passFocusNode,
                  validator: (val) => (val!.length < 6)
                      ? "Please enter a password with\nmore than 6 characters"
                      : null,
                  onChanged: (val) => pass = val,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (val) => FocusScope.of(context).unfocus(),
                  obscureText: _hidePassword,
                ),
                const SizedBox(
                  height: 40.0,
                  width: 0.0,
                ),
                TextButton(
                  style: authSignInBtnStyle(),
                  onPressed: () async => await signUpLogic(context),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: loading
                        ? const Loading(
                            white: true,
                          )
                        : const Text(
                            "Sign-up",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                  ),
                ),
              ],
            ),
          ),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }

  Future<void> signUpLogic(BuildContext context) async {
    if (_globalKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      dynamic result =
          await AuthenticationService().registerWithMailPass(name, mail, pass);
      result != null
          ? Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (builder) => HomePage(uid: result)),
              (route) => false)
          : setState(() {
              loading = false;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Couldn't sign-up, please try again later.\nPlease check credentials and/or network connection."),
              ));
            });
    }
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _passFocusNode.dispose();
    _mailFocusNode.dispose();
    super.dispose();
  }
}
