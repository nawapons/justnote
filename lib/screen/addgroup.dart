import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({Key? key}) : super(key: key);

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  var time = DateTime.now();
  addgrouptofirebase() async {
    var user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    await FirebaseFirestore.instance
        .collection('Group')
        .doc(uid)
        .collection('mygroup')
        .doc()
        .set({'groupname': _groupNameController.text, 'createAt': time});
    Fluttertoast.showToast(
        msg: "Group Add Successful...", gravity: ToastGravity.CENTER);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: const Text('Group Page'),
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
                    "New Group",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextField(
                    controller: _groupNameController,
                    decoration: const InputDecoration(
                        labelText: "Group name ...",
                        labelStyle:
                            TextStyle(fontSize: 16, color: Colors.grey))),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff262626)),
                    onPressed: () {
                      addgrouptofirebase();
                    },
                    child: const Text(
                      "Add New Group",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
