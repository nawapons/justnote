import 'package:flutter/material.dart';
import 'package:justnote/screen/login.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff262626),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: "logoTag",
                    child: Image.asset("assets/logo/AppLogo.png"),
                  ),
                  const Text(
                    "Just Note",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                        height: 3.0),
                  ),
                  const Text(
                    '"Effortlessly manage your tasks,\nset priorities, and accomplish more\nwith JUST NOTE"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                        width: 250,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffD9D9D9)),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const LoginScreen();
                              }));
                            },
                            child: const Text(
                              "Get Started",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ))),
                  )
                ],
              ),
            )));
  }
}
