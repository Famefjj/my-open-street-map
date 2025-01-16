import 'package:flutter/material.dart';
import 'components/map_screen_test.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Container(
          child: const Center(
            child: Text(
              'My Open Street Map',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          // padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              style: BorderStyle.solid,
              color: Colors.black,
            ),
          ),
          child: MapScreenTest(),
        ),
      ),
    );
  }
}
