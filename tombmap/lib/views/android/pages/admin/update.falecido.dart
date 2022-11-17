// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:tombmap/controllers/admin/falecido.controller.dart';
import 'package:tombmap/models/falecido.model.dart';

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
        title: Text('Dados Falecido'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed('/localizador');
          },
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Container(
                padding: EdgeInsets.all(48),
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.05),
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
                      child: Text(
                        'Atualizar Falecido',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: nome,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          hintText: 'Nome Completo',
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: latitude,
                        decoration: InputDecoration(
                          icon: Icon(Icons.description_rounded),
                          border: OutlineInputBorder(),
                          hintText: 'Latitude',
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: longitude,
                        decoration: InputDecoration(
                          icon: Icon(Icons.description_rounded),
                          border: OutlineInputBorder(),
                          hintText: 'Longitude',
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: lapide,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          hintText: 'Lapide',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () => save(context),
                        child: Center(
                          child: Text("Salvar"),
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
