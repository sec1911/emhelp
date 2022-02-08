import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmergencyCallPage(),
    );
  }
}

class EmergencyCallPage extends StatelessWidget {
  const EmergencyCallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 225),
                height: 225,
                width: 225,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectionPage()),
                    );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: const Icon(
                    Icons.call_rounded,
                    size: 125,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 200),
                child: const Text(
                  "Tap button for emergency call",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectionPage extends StatelessWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency App"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 125),
                  width: 175,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PoliceCallPage()),
                      );
                    },
                    child: const Text(
                      "Police",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 75),
                width: 175,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AmbulanceCallPage()),
                    );
                  },
                  child: const Text(
                    "Ambulance",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 75),
                width: 175,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FireFighterCallPage()),
                    );
                  },
                  child: const Text(
                    "Fire Fighter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 175),
                child: const Text(
                  "Tap any button for emergency call",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PoliceCallPage extends StatelessWidget {
  const PoliceCallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "You are calling a police!",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 25),
                height: 250,
                width: 340,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "P1",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "P2",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "P3",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "P4",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "P5",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                child: const TextField(
                  maxLength: 140,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your message",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Send",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            minimumSize: const Size(275, 50)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: FloatingActionButton(
                        backgroundColor: Colors.blueGrey,
                        onPressed: () {},
                        child: const Icon(
                          Icons.mic_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AmbulanceCallPage extends StatelessWidget {
  const AmbulanceCallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "You are calling an ambulance!",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 25),
                height: 250,
                width: 340,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "A1",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "A2",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "A3",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "A4",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "A5",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                child: const TextField(
                  maxLength: 140,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your message",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Send",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            minimumSize: const Size(275, 50)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: FloatingActionButton(
                        backgroundColor: Colors.blueGrey,
                        onPressed: () {},
                        child: const Icon(
                          Icons.mic_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FireFighterCallPage extends StatelessWidget {
  const FireFighterCallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "You are calling a fire fighter!",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 25),
                height: 250,
                width: 340,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "F1",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "F2",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "F3",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "F4",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "F5",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            primary: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                child: const TextField(
                  maxLength: 140,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your message",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 25),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Send",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            minimumSize: const Size(275, 50)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: FloatingActionButton(
                        backgroundColor: Colors.blueGrey,
                        onPressed: () {},
                        child: const Icon(
                          Icons.mic_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
