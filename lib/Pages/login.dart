import 'package:android_proj/main.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const Myapp());
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Text(
          "Login Page",
          style: TextStyle(
          fontSize: 30,
          color: Colors.blue,
          fontWeight: FontWeight.bold),

        ),
      ),
    );
  }
}
