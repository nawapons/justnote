import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:justnote/screen/homepage.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedGroupName;
  addtasktofirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    DateTime selectedDate =
        DateFormat('dd-MM-yyyy HH:mm').parse(_dateController.text);

    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'group': selectedGroupName ?? "Nogroup",
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date': Timestamp.fromDate(selectedDate),
      'status': 'active'
    });
    Fluttertoast.showToast(
        msg: "Task Add Successful...", gravity: ToastGravity.CENTER);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const HomePageScreen()));
  }

  late Stream<QuerySnapshot> _groupTasksStream;

  @override
  void initState() {
    super.initState();
    // Initialize your stream here
    final user = FirebaseAuth.instance.currentUser;
    String userid = user!.uid;
    _groupTasksStream = FirebaseFirestore.instance
        .collection("Group")
        .doc(userid)
        .collection("mygroup")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: const Text('Tasks Page'),
          leading: IconButton(
              icon: const Icon(BootstrapIcons.chevron_left,
                  color: Color(0xff262626)),
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HomePageScreen();
                  })))),
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
                    "New Task",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        labelText: "What's your plan ?",
                        labelStyle:
                            TextStyle(fontSize: 16, color: Colors.grey))),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        labelText: "Description",
                        labelStyle:
                            TextStyle(fontSize: 16, color: Colors.grey))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                      labelText: "DATE",
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                      prefixIconColor: Color(0xff262626),
                      labelStyle: TextStyle(color: Color(0xff262626)),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff262626)))),
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                  }),
              const SizedBox(
                height: 20,
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
                      return const Text("You have no group.");
                    }
                    List<String> groupNames = snapshot.data!.docs
                        .map((doc) => doc['groupname'] as String)
                        .toList();
                    return SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value:
                            selectedGroupName, // Set the initial value or null
                        onChanged: (String? newValue) {
                          // Handle dropdown value change
                          setState(() {
                            selectedGroupName = newValue!;
                          });
                        },
                        items: groupNames.map((String groupName) {
                          return DropdownMenuItem<String>(
                            value: groupName,
                            child: Text(groupName),
                          );
                        }).toList(),
                        hint: const Padding(
                          padding: EdgeInsets.only(
                              left: 8.0), // Adjust left padding as needed
                          child: Text('Select Group'),
                        ),
                        icon: const Icon(Icons.arrow_drop_down), // Arrow icon
                        iconSize: 24, // Adjust icon size as needed
                        isExpanded: true,
                        underline: Container(
                          height: 2,
                          color: const Color(
                              0xff403D39), // Customize the underline color
                        ),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                        // Other properties and customization as needed
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff262626)),
                    onPressed: () {
                      addtasktofirebase();
                    },
                    child: const Text(
                      "Add New Task",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime intialDate = DateTime.now();
    await showDatePicker(
        context: context,
        initialDate: intialDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: intialDate,
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                    primary: Color(0xff262626),
                    onPrimary: Colors.white,
                    onSurface: Color.fromARGB(255, 121, 112, 102))),
            child: child!,
          );
        }).then((selectedDate) {
      // After selecting the date, display the time picker.
      if (selectedDate != null) {
        showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                        primary: Color(0xff262626),
                        onSurface: Color(0xff403D39))),
                child: child!,
              );
            }).then((selectedTime) {
          // Handle the selected date and time here.
          if (selectedTime != null) {
            setState(() {
              DateTime selectedDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              _dateController.text =
                  DateFormat('dd-MM-yyyy HH:mm').format(selectedDateTime);
            });
          }
        });
      }
    });
  }
}
