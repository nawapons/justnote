import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justnote/screen/changepassword.dart';

class ProfileWidgets extends StatefulWidget {
  const ProfileWidgets({Key? key}) : super(key: key);

  @override
  State<ProfileWidgets> createState() => _ProfileWidgetsState();
}

class _ProfileWidgetsState extends State<ProfileWidgets> {
  late String? userid;
  late String? email;
  late String? name;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userid = user!.uid;
    email = user.email ?? "";
    name = user.displayName ?? "";
    _nameController.text = name ?? "";
  }

  Future<void> _updateDisplayName(String newName) async {
    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(newName);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Display name updated successfully'),
        ),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update display name'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 30, top: 10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Profile",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "* email cannot be changed",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: email),
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
                  labelText: 'Email',
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
                controller: _nameController,
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
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Color(0xff262626)),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                // Handle the click action here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()),
                );
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Change Password",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff262626),
                ),
                onPressed: () {
                  final newName = _nameController.text.trim();
                  if (newName.isNotEmpty) {
                    _updateDisplayName(newName);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid name'),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Save changes",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
