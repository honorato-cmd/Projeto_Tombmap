// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class Inicial extends StatefulWidget {
  const Inicial({Key? key}) : super(key: key);

  @override
  State<Inicial> createState() => _InicialState();
}

class _InicialState extends State<Inicial> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'images/logo.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.05,
                    margin: EdgeInsets.only(top: 5),
                    child: GFButton(
                      type: GFButtonType.outline,
                      shape: GFButtonShape.pills,
                      color: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Administrador'.toUpperCase(), 
                          style: TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.05,
                  margin: EdgeInsets.only(top: 20),
                  child: GFButton(
                      shape: GFButtonShape.pills,
                      color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/localizadorfalecido');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Usuário'.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
