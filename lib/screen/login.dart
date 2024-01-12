import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:justnote/model/login.dart';
import 'package:justnote/screen/homepage.dart';
import 'package:justnote/screen/main.dart';
import 'package:justnote/screen/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Login login = Login(email: '', password: '');
  late final Future<FirebaseApp> firebase;

  final db = FirebaseFirestore.instance;

  Future<void> logIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  void initState() {
    super.initState();
    firebase = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                backgroundColor: const Color(0xff262626),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xff262626),
                  elevation: 0.0,
                  leading: IconButton(
                    icon: const Icon(BootstrapIcons.chevron_left,
                        color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const MainPage();
                      }),
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 200, bottom: 120),
                            child: Text(
                              "Welcome\nBack",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 27),
                            ),
                          ),
                          SizedBox(
                              height: 70,
                              child: TextFormField(
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Please enter your email"),
                                  EmailValidator(
                                      errorText: "Email type is not valid")
                                ]),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (email) => login.email = email!,
                                cursorColor: Colors.black,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    border: OutlineInputBorder(),
                                    hintText: 'Email',
                                    suffixIcon: Icon(BootstrapIcons.envelope),
                                    suffixIconColor: Colors.black54,
                                    filled: true,
                                    fillColor: Color(0xffD9D9D9)),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              height: 70,
                              child: TextFormField(
                                validator: RequiredValidator(
                                    errorText: "Please enter your password"),
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                cursorColor: Colors.black,
                                onSaved: (password) =>
                                    login.password = password!,
                                decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    border: OutlineInputBorder(),
                                    hintText: 'Password',
                                    suffixIcon:
                                        Icon(BootstrapIcons.shield_lock),
                                    suffixIconColor: Colors.black54,
                                    filled: true,
                                    fillColor: Color(0xffD9D9D9)),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          Hero(
                              tag: "loginActionButton",
                              child: SizedBox(
                                height: 40,
                                width: 350,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xffCCC5B9)),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState?.save();
                                        try {
                                          await logIn(
                                              login.email, login.password);
                                          formKey.currentState!.reset();
                                          Fluttertoast.showToast(
                                              msg: "Login successful...",
                                              gravity: ToastGravity.CENTER);
                                          // ignore: use_build_context_synchronously
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomePageScreen()));
                                        } on FirebaseAuthException catch (e) {
                                          // ignore: avoid_print
                                          String message;
                                          if (e.code ==
                                              "INVALID_LOGIN_CREDENTIALS") {
                                            message =
                                                "Email or password is invalid";
                                          } else {
                                            message =
                                                "Something went wrong.. Please try again!";
                                          }
                                          Fluttertoast.showToast(
                                              msg: message,
                                              gravity: ToastGravity.CENTER);
                                        }
                                      }
                                    },
                                    child: const Text(
                                      "Sign-in",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    )),
                              )),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10.0,
                                          left: 10.0,
                                          right: 20.0,
                                          bottom: 10.0),
                                      child: const Divider(
                                        color: Colors.white,
                                      ))),
                              const Text(
                                "Don't have account ?",
                                style: TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10.0,
                                          left: 10.0,
                                          right: 20.0,
                                          bottom: 10.0),
                                      child: const Divider(
                                        color: Colors.white,
                                      ))),
                            ],
                          ),
                          Hero(
                            tag: "registerActionButton",
                            child: SizedBox(
                              height: 40,
                              width: 350,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterScreen()));
                                  },
                                  child: const Text(
                                    "Create account",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          }
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}
