// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:tombmap/controllers/admin/falecido.controller.dart';
import 'package:tombmap/models/falecido.model.dart';
import 'package:getwidget/getwidget.dart';

class UpdateFalecidoPage extends StatelessWidget {
  String id = "";
  var nome = TextEditingController();
  var latitude = TextEditingController();
  var longitude = TextEditingController();
  var lapide = TextEditingController();

  UpdateFalecidoPage(falecido) {
    id = falecido["id"].toString();
    nome.text = falecido["nome"];
    latitude.text = falecido["latitude"];
    longitude.text = falecido["longitude"];
    lapide.text = falecido["lapide"];
  }

  void save(BuildContext context) async {
    var falecidoController = FalecidoController();

    CadastroFalecidos falecidos = CadastroFalecidos(
        id: id,
        nome: nome.text,
        latitude: latitude.text,
        longitude: longitude.text,
        lapide: lapide.text);

    await falecidoController.update(falecidos);

    Navigator.of(context).pushNamed("/listfalecido");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Atualização Falecido - ' + nome.text,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed('/cadastro');
            }),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
                child: Wrap(
                  runSpacing: 20,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      width: double.infinity,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: nome,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person, color: Colors.black),
                            border: OutlineInputBorder(),
                            hintText: 'Nome Completo',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: latitude,
                        enabled: false,
                        decoration: InputDecoration(
                            icon: Icon(Icons.map, color: Colors.black),
                            border: OutlineInputBorder(),
                            hintText: 'CPF',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: longitude,
                        enabled: false,
                        decoration: InputDecoration(
                            icon: Icon(Icons.map, color: Colors.black),
                            border: OutlineInputBorder(),
                            hintText: 'Longitude',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: lapide,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock, color: Colors.black),
                            border: OutlineInputBorder(),
                            hintText: 'Lapide',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        obscureText: false,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 250),
                      child: GFButton(
                        shape: GFButtonShape.pills,
                        color: Colors.black,
                        onPressed: 
                          () => save(context),

                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Editar'.toUpperCase(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
