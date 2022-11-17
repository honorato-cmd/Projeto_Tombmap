// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tombmap/views/android/pages/admin/cadastroadmin.dart';
import 'package:tombmap/views/android/pages/admin/cadastrofalecido.dart';
import 'package:tombmap/views/android/pages/admin/listadm.dart';

class Localizador extends StatefulWidget {
  const Localizador({Key? key}) : super(key: key);

  @override
  State<Localizador> createState() => _LocalizadorState();
}

class _LocalizadorState extends State<Localizador> {
  TextEditingController nome = TextEditingController();
  TextEditingController lapide = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  children: [
                    Container(
                      height: 30,
                    ),
                    TextField(
                      controller: nome,
                      keyboardType: TextInputType.name, // teclado só numérico
                      decoration: InputDecoration(
                        labelText: 'Digite o nome ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    TextField(
                      controller: lapide,
                      keyboardType: TextInputType.number, // teclado só numérico
                      decoration: InputDecoration(
                        labelText: 'Digite a lápide ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          MapsLauncher.launchQuery('Cemitério');
                        },
                        child: Text("Pesquisar"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          onPress: () {
            Navigator.of(context).pushNamed('/cadastro');
          },
        ),
      ),
    );
  }
}
