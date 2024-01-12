import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Function() onAddTasksPressed; // New callback for "Tasks" button

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onAddTasksPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Color(0xff262626),
        ),
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.list_task),
          label: 'Tasks',
          backgroundColor: Color(0xff262626),
        ),
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.plus),
          label: 'Add Tasks',
          backgroundColor: Color(0xff262626),
        ),
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.stack),
          label: 'Groups',
          backgroundColor: Color(0xff262626),
        ),
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.person_circle),
          label: 'Profile',
          backgroundColor: Color(0xff262626),
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.white,
      onTap: (index) {
        if (index == 2) {
          // If "Tasks" button is tapped, invoke the onTasksPressed callback
          onAddTasksPressed();
        } else {
          // For other buttons, invoke the onItemTapped callback
          onItemTapped(index);
        }
      },
    );
  }
}
