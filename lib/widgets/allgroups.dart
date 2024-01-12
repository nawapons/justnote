import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:justnote/screen/addgroup.dart';
import 'package:justnote/screen/groupdescription.dart';

class AllGroupsWidget extends StatefulWidget {
  const AllGroupsWidget({super.key});

  @override
  State<AllGroupsWidget> createState() => _AllGroupsWidgetState();
}

class _AllGroupsWidgetState extends State<AllGroupsWidget> {
  final user = FirebaseAuth.instance.currentUser;
  late String userid = user!.uid;

  late final _groupTasksStream = FirebaseFirestore.instance
      .collection("Group")
      .doc(userid)
      .collection("mygroup")
      .orderBy("createAt", descending: true)
      .snapshots();
  Stream<QuerySnapshot> getTasksStream(String groupName) {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .doc(userid)
        .collection("mytasks")
        .where("group", isEqualTo: groupName)
        .snapshots();
  }

  late Future<int> count = _groupTasksStream.length;
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

  Future<void> _showDeleteConfirmationDialog(DocumentSnapshot document) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content:
              const Text("Warning : All tasks in this group will be delete."),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xff262626)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xff262626)),
              ),
              onPressed: () async {
                await _deleteGroupAndTasks(document);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteGroupAndTasks(DocumentSnapshot document) async {
    try {
      DocumentReference groupRef = document.reference;

      // Get the group data
      Map<String, dynamic> groupData = document.data()! as Map<String, dynamic>;
      String groupName = groupData["groupname"];

      // Delete tasks associated with the group
      getTasksStream(groupName).listen((QuerySnapshot tasksSnapshot) {
        tasksSnapshot.docs.forEach((taskDoc) {
          taskDoc.reference.delete();
        });
      }).asFuture();

      // Remove the group
      await groupRef.delete();

      Fluttertoast.showToast(
        msg: "Group and associated tasks removed successfully",
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Something went wrong!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 4, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "All Groups",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            StreamBuilder(
              stream: _groupTasksStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Couting...");
                }

                int groupCount = snapshot.data?.docs.length ?? 0;

                return Text(
                  "Total Groups: $groupCount",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      StreamBuilder(
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
            spacing: 20.0,
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
                      child: GestureDetector(
                        onLongPress: () {
                          _showDeleteConfirmationDialog(document);
                        },
                        child: FloatingActionButton(
                          heroTag: UniqueKey(),
                          backgroundColor: const Color(0xff403D39),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GroupDescriptionScreen(
                                            groupname:
                                                groupData["groupname"])));
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
                                    top: 20, left: 5, right: 5),
                                child: Text(
                                  "${tasksSnapshot.data!.docs.length} Tasks",
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
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
      )
    ]);
  }
}
