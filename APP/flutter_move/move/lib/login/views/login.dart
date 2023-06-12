import 'package:flutter/material.dart';
import '../formularios/form_login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/fondologin.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
              Container(
                height: 545,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 32, 136, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                alignment: Alignment.center,
                child: const FormLogin(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
