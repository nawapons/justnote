import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justnote/screen/addgroup.dart';
import 'package:justnote/screen/groupdescription.dart';

class GroupTasksWidget extends StatefulWidget {
  const GroupTasksWidget({super.key});

  @override
  State<GroupTasksWidget> createState() => _GroupTasksWidgetState();
}

class _GroupTasksWidgetState extends State<GroupTasksWidget> {
  final user = FirebaseAuth.instance.currentUser;
  late String userid = user!.uid;

  late final _groupTasksStream = FirebaseFirestore.instance
      .collection("Group")
      .doc(userid)
      .collection("mygroup")
      .limit(3)
      .snapshots();
  Stream<QuerySnapshot> getTasksStream(String groupName) {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .doc(userid)
        .collection("mytasks")
        .where("group", isEqualTo: groupName)
        .snapshots();
  }

  Widget buildAddGroupButton() {
    return SizedBox(
      height: 110.0,
      width: 150.0,
      child: FloatingActionButton(
        heroTag: "AddGroup",
        backgroundColor: const Color(0xff403D39),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const AddGroupScreen();
        })),
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8, left: 5, right: 5),
              child: Icon(
                Icons.add,
                size: 50,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1),
              child: Text("Add new group"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _groupTasksStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Connection Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 30,
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return buildAddGroupButton();
        }
        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 5.0,
          runSpacing: 5.0,
          children: [
            ...snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> groupData =
                  document.data()! as Map<String, dynamic>;
              String groupName = groupData["groupname"] ?? "defaultGroupName";

              return StreamBuilder(
                stream: getTasksStream(groupName),
                builder: (context, tasksSnapshot) {
                  if (tasksSnapshot.hasError) {
                    return const Text("Connection Error");
                  }
                  if (tasksSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox(
                      height: 30,
                      child: CircularProgressIndicator(),
                    );
                  }

                  return SizedBox(
                    height: 110.0,
                    width: 150.0,
                    child: FloatingActionButton(
                      heroTag: UniqueKey(),
                      backgroundColor: const Color(0xff403D39),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GroupDescriptionScreen(
                                    groupname: groupData["groupname"])));
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 5, right: 5),
                            child: Text(
                              groupData["groupname"],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, left: 5, right: 5),
                            child: Text(
                              "${tasksSnapshot.data!.docs.length} Tasks",
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
            buildAddGroupButton(),
          ],
        );
      },
    );
  }
}
