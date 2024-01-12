import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:justnote/screen/addtask.dart';
import 'package:justnote/screen/main.dart';
import 'package:justnote/widgets/allgroups.dart';
import 'package:justnote/widgets/alltasks.dart';
import 'package:justnote/widgets/homepage.dart';
import 'package:justnote/widgets/navigationbar.dart';
import 'package:justnote/widgets/profile.dart'; // Import the new file

class HomePageScreen extends StatefulWidget {
  final int? receivedIndex;
  const HomePageScreen({super.key, this.receivedIndex});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    // Check if receivedIndex is not null, otherwise set _selectedIndex to 0
    _selectedIndex = widget.receivedIndex ?? 0;
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomepageWidgets(),
    AllTasksWidgets(),
    // Text(
    //   'Tasks',
    //   style: optionStyle,
    // ),
    Text(
      'Add Task',
      style: optionStyle,
    ),
    AllGroupsWidget(),
    ProfileWidgets(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddTasksPressed() {
    // Navigate to the Tasks page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddTaskScreen(), // Replace 'TasksPage' with your actual Tasks page
      ),
    );
  }

  String? getFirstName(String? fullName) {
    if (fullName != null) {
      List<String> nameParts = fullName.split(" ");
      return nameParts.isNotEmpty ? nameParts[0] : null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          "Hi, ${getFirstName(auth.currentUser?.displayName) ?? "Null"}",
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            child: Hero(
              tag: 'logoutActionButton',
              child: Material(
                child: IconButton(
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainPage()));
                    });
                  },
                  icon: const Icon(
                    BootstrapIcons.box_arrow_right,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        onAddTasksPressed: _onAddTasksPressed,
      ),
    );
  }
}
