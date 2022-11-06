import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int days = 30;
    double d = 2.1;
    var a = days+d;
    return Scaffold(
      appBar: AppBar(
        title: Text("Scheduler"),
      ),
      body: Center(
        child: Container(
          child: Text("welcome to $a days of flutter by Parth"),
        ),
      ),
      drawer: Drawer(),
    );
  }
}
