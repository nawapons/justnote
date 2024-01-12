import 'package:flutter/material.dart';
import 'package:justnote/screen/homepage.dart';
import 'package:justnote/widgets/groupTasks.dart';
import 'package:justnote/widgets/todoTasks.dart';

class HomepageWidgets extends StatelessWidget {
  const HomepageWidgets({super.key});
  Widget buildGroupActionButton(String groupName, String tasks) {
    return SizedBox(
      height: 110.0,
      width: 150.0,
      child: FloatingActionButton(
        heroTag: UniqueKey(),
        backgroundColor: const Color(0xff403D39),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
              child: Text(
                groupName,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
              child: Text(
                tasks,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddGroupButton() {
    return SizedBox(
      height: 110.0,
      width: 150.0,
      child: FloatingActionButton(
        heroTag: "AddGroup",
        backgroundColor: const Color(0xff403D39),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          // Add your onPressed code here!
        },
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
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Group Tasks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePageScreen(
                                receivedIndex: 3,
                              )),
                    );
                  },
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            const GroupTasksWidget(),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Today's Tasks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePageScreen(
                                receivedIndex: 1,
                              )),
                    );
                  },
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            const TodoTasksWidget(),
          ],
        ),
      ),
    );
  }
}
