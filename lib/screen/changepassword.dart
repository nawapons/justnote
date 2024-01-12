import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justnote/screen/main.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late String message;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<bool> changePassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if the new password is the same as the confirm password
        if (_newPasswordController.text != _confirmPasswordController.text) {
          // Show an error message or handle the case where passwords don't match
          message = "New password and confirm password do not match.";
          return false;
        }

        // Check if the current password matches the current password in Firebase authentication
        final AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: _currentPasswordController.text);
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(_newPasswordController.text);
        return true; // Password change successful
      } else {
        // Handle the case where the user is not signed in
        return false;
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "INVALID_LOGIN_CREDENTIALS") {
        message = "Curent password is not correct.";
        return false;
      } else {
        message = "Something wrong please try again..";
        return false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: const Text('Changepassword Page'),
          leading: IconButton(
              icon: const Icon(BootstrapIcons.chevron_left,
                  color: Color(0xff262626)),
              onPressed: () => Navigator.pop(context))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30, top: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Change Password",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextField(
                  readOnly: false,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _currentPasswordController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff262626),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    labelText: 'Current Password',
                    labelStyle: TextStyle(color: Color(0xff262626)),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextField(
                  readOnly: false,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff262626),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: Color(0xff262626)),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextField(
                  readOnly: false,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff262626),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Color(0xff262626)),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Required to re-login",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff262626),
                  ),
                  onPressed: () async {
                    // Call the changePassword function
                    bool success = await changePassword();

                    // Check if password change is successful
                    if (success) {
                      // If successful, perform re-login or navigate to login screen
                      // For example, you can use Navigator to pop the current screen and go back to the login screen
                      auth.signOut().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()));
                      });
                      // You might also want to show a snackbar or alert indicating successful password change
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Confirm change",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
