// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tombmap/controllers/admin/falecido.controller.dart';
import 'package:tombmap/models/falecido.model.dart';
import 'package:getwidget/getwidget.dart';

class CadastrosFalecidos extends StatefulWidget {
  @override
  State<CadastrosFalecidos> createState() => _CadastrosFalecidosState();
}

class _CadastrosFalecidosState extends State<CadastrosFalecidos> {
  int? id;

  var nome = TextEditingController();
  var longitudeController = TextEditingController();
  var latitudeController = TextEditingController();

  double? latitude;

  double? longitude;

  var lapide = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void salvar(BuildContext context) async {
    var falecidoController = FalecidoController();

    await falecidoController.create(CadastroFalecidos(
      nome: nome.text,
      latitude: latitude.toString(),
      longitude: longitude.toString(),
      lapide: lapide.text,
    ));
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/listfalecido', (route) => false);
  }

  @override
  void initState() {
    pegarPosicao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro Falecidos',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushNamed('/cadastro');
          },
        ),
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
                        enabled: false,
                        controller: latitudeController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.map, color: Colors.black),
                            border: OutlineInputBorder(),
                            hintText: 'Latitude',
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
                        enabled: false,
                        controller: longitudeController,
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
                            icon: Icon(Icons.church, color: Colors.black),
                            border: OutlineInputBorder(),
                            hintText: 'Lápide',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        obscureText: false,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 220),
                      child: GFButton(
                        shape: GFButtonShape.pills,
                        color: Colors.black,
                        onPressed: () => salvar(context),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Cadastrar'.toUpperCase(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.0),
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

  pegarPosicao() async {
    Position posicao = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = posicao.latitude;
      longitude = posicao.longitude;

      longitudeController.text = posicao.longitude.toString();
      latitudeController.text = posicao.latitude.toString();
    });
  }
}
