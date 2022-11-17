// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LocalizadorFalecido extends StatefulWidget {
  const LocalizadorFalecido({Key? key}) : super(key: key);

  @override
  State<LocalizadorFalecido> createState() => _LocalizadorFalecidoState();
}

class _LocalizadorFalecidoState extends State<LocalizadorFalecido> {
  TextEditingController nome = TextEditingController();
  TextEditingController lapide = TextEditingController();

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
          title: Text('Usuário'),
          centerTitle: true,
        ),
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
                        onPressed: () {},
                        child: Text("Pesquisar"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
