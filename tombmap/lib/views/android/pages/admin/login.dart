// ignore_for_file: avoid_web_libraries_in_flutter
// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tombmap/controllers/admin/admin.controller.dart';
import 'package:tombmap/models/admin.model.dart';

const kBackgroundColor = Color(0xFF202020);
const kPrimaryColor = Color(0xFFFFBD73);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final senha = TextEditingController();
  final adminController = new AdminController();

  void Autenticar() async {
    final result =
        await adminController.read_Email_Senha(email.text, senha.text);
    if (result.isNotEmpty) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/localizador', (route) => false);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: (IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_outlined),
          )),
          title: Text('Login de Administrador'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20,
              ),
              SizedBox(
                width: 180,
                height: 180,
                child: Image.asset('images/admin.jpeg'),
              ),
              Container(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ignore_for_file: prefer_const_constructors
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.alternate_email,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                          labelText: 'Usuário',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: senha,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              CupertinoButton.filled(
                child: Text('Entrar'),
                onPressed: () => Autenticar(),
                padding: EdgeInsets.all(15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
