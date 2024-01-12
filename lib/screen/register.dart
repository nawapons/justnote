import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:justnote/model/profile.dart';
import 'package:justnote/screen/main.dart';
import 'package:justnote/screen/login.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(name: '', email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  final db = FirebaseFirestore.instance;

  Future<void> registerUser(String email, String password, String name) async {
    //Create the user with auth
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    //Create the user in firestore with the user data
    User? user = result.user;
    user?.updateDisplayName(name);
  }

  @override
  void initState() {
    super.initState();
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
                    backgroundColor: const Color(0xff262626),
                    automaticallyImplyLeading: false,
                    elevation: 0.0,
                    leading: IconButton(
                        icon: const Icon(BootstrapIcons.chevron_left,
                            color: Colors.white),
                        onPressed: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const MainPage();
                            })))),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 200, bottom: 70),
                            child: Text(
                              "Create\nAccount",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 27),
                            ),
                          ),
                          SizedBox(
                              height: 70,
                              child: TextFormField(
                                validator: RequiredValidator(
                                    errorText: "Please enter your name"),
                                keyboardType: TextInputType.name,
                                onSaved: (name) => profile.name = name!,
                                cursorColor: Colors.black,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  border: OutlineInputBorder(),
                                  hintText: 'Name',
                                  suffixIcon: Icon(BootstrapIcons.person),
                                  suffixIconColor: Colors.black54,
                                  filled: true,
                                  fillColor: Color(0xffD9D9D9),
                                ),
                              )),
                          const SizedBox(
                            height: 15,
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
                                onSaved: (email) => profile.email = email!,
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
                                onSaved: (password) =>
                                    profile.password = password!,
                                obscureText: true,
                                cursorColor: Colors.black,
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
                          SizedBox(
                            height: 40,
                            width: 350,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffCCC5B9)),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState?.save();
                                    try {
                                      await registerUser(profile.email,
                                          profile.password, profile.name);
                                      formKey.currentState!.reset();
                                      Fluttertoast.showToast(
                                          msg:
                                              "Create user successfully! Please Sign-in",
                                          gravity: ToastGravity.CENTER);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const LoginScreen();
                                      }));
                                    } on FirebaseAuthException catch (e) {
                                      // ignore: avoid_print
                                      late String message;
                                      if (e.code == "email-already-in-use") {
                                        message =
                                            "This email is already to use";
                                      } else if (e.code == "weak-password") {
                                        message =
                                            "Password should be at least 6 characters";
                                      }
                                      Fluttertoast.showToast(
                                          msg: message,
                                          gravity: ToastGravity.CENTER);
                                    }
                                  }
                                },
                                child: const Text(
                                  "Create account",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                )),
                          ),
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
                                "Have account already ?",
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
                          SizedBox(
                            height: 40,
                            width: 350,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const LoginScreen();
                                  }));
                                },
                                child: const Text(
                                  "Sign in",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
