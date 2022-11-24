import 'dart:convert';
import 'dart:math';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tombmap/controllers/admin/admin.controller.dart';
import 'package:tombmap/views/android/pages/admin/updateemail.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfirmaEmail extends StatefulWidget {
  @override
  _ConfirmaEmailState createState() => _ConfirmaEmailState();
}

class _ConfirmaEmailState extends State<ConfirmaEmail> {
  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  var numero = 0;
  String errorMsg = "";
  var emailcontroller = TextEditingController();
  String _text = '';
  late Position _currentPosition;
  var numerocontroller = TextEditingController();

  void MontarNumero() async {
    var adminController = AdminController();
    final result = await adminController.atualizacao(emailcontroller.text);
    numero = random(1000, 10000);
    Future sendEmail({
      required String emailcontroller,
      required String subject,
      required String mensagem,
    }) async {
      final serviceId = 'service_c46onf4';
      final templateId = 'template_zaf5n4g';
      final userId = 'M4VBXPzBEgq2ovsGX';

      final Url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(Url,
          headers: {
            'origin': 'http://localhost',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'user_email': emailcontroller.toString(),
              'user_subject': 'Um usuário está tentando alterar sua senha',
              'user_message': numero.toString(),
            }
          }));
    }

    if (emailcontroller.text == 'admin@admin.com') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          backgroundColor: Colors.white,
          title: Text('Alteração Inválida'),
          content: Text('O ADMIN não pode ser alterado'),
          actions: [
            GFButton(
              shape: GFButtonShape.pills,
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'OK'.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (result["nome"] != "" &&
        numero != 0 &&
        emailcontroller.text != 'admin@admin.com') {
      print(numero);
      print("Email enviado");
      await sendEmail(
          emailcontroller: emailcontroller.text,
          subject: 'Um usuário está tentando alterar sua senha',
          mensagem: numero.toString());
      print(numerocontroller.text);
      print(numero.toString());
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                backgroundColor: Colors.white,
                title: Text('Confirmação numérica'),
                content: TextFormField(
                  cursorColor: Colors.black,
                  controller: numerocontroller,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      icon: Icon(Icons.numbers, color: Colors.black),
                      border: OutlineInputBorder(),
                      hintText: 'Número recebido',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
                actions: [
                  GFButton(
                    shape: GFButtonShape.pills,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'Não'.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                  GFButton(
                    shape: GFButtonShape.pills,
                    color: Colors.black,
                    onPressed: () {
                      if (numerocontroller.text == numero.toString()) {
                        print("Entrou");
                        atualizar();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'Prosseguir'.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                ],
              ));
    }
    ;
  }

  void atualizar() async {
    var adminController = AdminController();
    final result = await adminController.atualizacao(emailcontroller.text);

    print(numero);

    if (numerocontroller.text == numero.toString()) {
      print("Entrou");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => UpdateEmail(result)));
    }

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirmação E-Mail",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
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
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
                child: Wrap(
                  runSpacing: 20,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 150),
                      child: GFButton(
                        shape: GFButtonShape.pills,
                        color: Colors.black,
                        onPressed: () {
                          MontarNumero();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Atualizar'.toUpperCase(),
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
