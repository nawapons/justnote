import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:justnote/screen/description.dart';

class GroupDescriptionScreen extends StatefulWidget {
  final String groupname;
  const GroupDescriptionScreen({super.key, required this.groupname});

  @override
  State<GroupDescriptionScreen> createState() => _GroupDescriptionScreenState();
}

class _GroupDescriptionScreenState extends State<GroupDescriptionScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late String userid = user!.uid;

  late final _groupTasksStream = FirebaseFirestore.instance
      .collection("Tasks")
      .doc(userid)
      .collection("mytasks")
      .where("group", isEqualTo: widget.groupname)
      .where("status", isEqualTo: "active")
      .orderBy("date", descending: true) // Descending for "date"
      .snapshots();
  late final _tasksDoneStream = FirebaseFirestore.instance
      .collection("Tasks")
      .doc(userid)
      .collection("mytasks")
      .where("group", isEqualTo: widget.groupname)
      .where("status", isEqualTo: "completed")
      .orderBy("date", descending: true) // Descending for "date"
      .snapshots();
  void _updateTaskStatus(DocumentSnapshot document, bool newValue) {
    // Get the document reference
    DocumentReference taskRef = document.reference;

    // Update the status in Firestore
    taskRef.update({'status': newValue ? 'completed' : 'active'}).then((value) {
      Fluttertoast.showToast(
        msg: "Tasks status updated",
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: "Something went wrong!",
      );
    });
  }

  Future<void> _deleteTask(DocumentSnapshot document) async {
    try {
      // Get the document reference
      DocumentReference taskRef = document.reference;

      // Remove the task
      await taskRef.delete();
      Fluttertoast.showToast(
        msg: "Tasks remove successfully",
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Something went wrong!",
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(DocumentSnapshot document) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
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
                await _deleteTask(document);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String groupName = widget.groupname;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Text(
              "Group : ${groupName}",
              style: TextStyle(color: Colors.black),
            ),
            leading: IconButton(
                icon: const Icon(BootstrapIcons.chevron_left,
                    color: Color(0xff262626)),
                onPressed: () => Navigator.pop(context))),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 4, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "All Tasks",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  StreamBuilder(
                    stream: _groupTasksStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Couting...");
                      }

                      int taskCount = snapshot.data?.docs.length ?? 0;

                      return Text(
                        "Total Tasks: $taskCount",
                        style: TextStyle(
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
                    return const Center(
                      child: Text("No Tasks available.."),
                    );
                  }
                  return Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    Timestamp timestamp = data['date'] as Timestamp;
                    DateTime date = timestamp.toDate();
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TaskDescription(
                                    title: data["title"],
                                    description: data["description"],
                                    time: DateFormat('dd-MM-yyyy HH:mm')
                                        .format(date),
                                    status: data["status"],
                                    group: data["group"])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 7.0, left: 20, right: 20),
                        child: Container(
                          width: double.infinity,
                          height: 75,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 241, 241),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffCCC5B9),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              width: 10,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(data["title"]),
                                      subtitle: Text(
                                          DateFormat('dd-MM-yyyy HH:mm')
                                              .format(date)),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Transform.scale(
                                            scale: 1.1,
                                            child: Checkbox(
                                              activeColor:
                                                  const Color(0xff262626),
                                              shape: const CircleBorder(),
                                              value:
                                                  data["status"] == "completed",
                                              onChanged: (value) {
                                                setState(() {
                                                  _updateTaskStatus(
                                                      document, value!);
                                                });
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              BootstrapIcons.trash_fill,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              _showDeleteConfirmationDialog(
                                                  document);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  }).toList());
                }),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 4, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Tasks Done",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  StreamBuilder(
                    stream: _tasksDoneStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Couting...");
                      }

                      int taskCount = snapshot.data?.docs.length ?? 0;

                      return Text(
                        "Total Tasks: $taskCount",
                        style: TextStyle(
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
                stream: _tasksDoneStream,
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
                    return const Center(
                      child: Text("No Tasks Done...."),
                    );
                  }
                  return Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    Timestamp timestamp = data['date'] as Timestamp;
                    DateTime date = timestamp.toDate();
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TaskDescription(
                                    title: data["title"],
                                    description: data["description"],
                                    time: DateFormat('dd-MM-yyyy HH:mm')
                                        .format(date),
                                    status: data["status"],
                                    group: data["group"])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 7.0, left: 20, right: 20),
                        child: Container(
                          width: double.infinity,
                          height: 75,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 241, 241),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xff403D39),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              width: 10,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        data["title"],
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      subtitle: Text(
                                        DateFormat('dd-MM-yyyy HH:mm')
                                            .format(date),
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Transform.scale(
                                            scale: 1.1,
                                            child: Checkbox(
                                              activeColor:
                                                  const Color(0xff262626),
                                              shape: const CircleBorder(),
                                              value:
                                                  data["status"] == "completed",
                                              onChanged: (value) {
                                                setState(() {
                                                  _updateTaskStatus(
                                                      document, value!);
                                                });
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              BootstrapIcons.trash_fill,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              _showDeleteConfirmationDialog(
                                                  document);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  }).toList());
                })
          ],
        ));
  }
}
