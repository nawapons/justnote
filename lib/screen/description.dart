import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

class TaskDescription extends StatelessWidget {
  final String title, description, time, status, group;

  const TaskDescription(
      {super.key,
      required this.title,
      required this.description,
      required this.time,
      required this.status,
      required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: const Text(
              "Description",
              style: TextStyle(color: Colors.black),
            ),
            leading: IconButton(
                icon: const Icon(BootstrapIcons.chevron_left,
                    color: Color(0xff262626)),
                onPressed: () => Navigator.pop(context))),
        body: Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: const EdgeInsets.all(10),
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Center(
                        child: Text(
                      status,
                      style: TextStyle(
                          color: status == "active"
                              ? Colors.orange.shade300
                              : Colors.green,
                          fontWeight: FontWeight.bold),
                    )),
                  ],
                ))),
            Container(
              margin:
                  const EdgeInsets.only(top: 3, left: 20, bottom: 3, right: 20),
              child: const Text(
                "Description",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            Center(
              child: Card(
                elevation: 0,
                color: Colors.grey.shade200,
                child: SizedBox(
                  width: 300,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(description),
                  ),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(top: 3, left: 20, bottom: 3, right: 20),
              child: Text(
                "Deadline : $time",
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(top: 3, left: 20, bottom: 3, right: 20),
              child: Text(
                "Group : $group",
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
            )
          ]),
        ));
  }
}
