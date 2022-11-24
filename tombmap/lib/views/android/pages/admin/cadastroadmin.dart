// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:tombmap/controllers/admin/admin.controller.dart';
import 'package:tombmap/models/admin.model.dart';
import 'package:getwidget/getwidget.dart';

class CadastroAdministrador extends StatelessWidget {
  int? id;
  var nome = TextEditingController();
  var cpf = TextEditingController();
  var email = TextEditingController();
  var senha = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void save(BuildContext context) async {
    var adminController = AdminController();

    await adminController.create(CadastroAdmin(
        nome: nome.text, cpf: cpf.text, email: email.text, senha: senha.text));
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/cadastro', (route) => false);
  }

  void update() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro Administrador',
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
                        controller: cpf,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            icon: Icon(Icons.description_rounded,
                                color: Colors.black),
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
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email,
                                color: Colors.black),
                            border: OutlineInputBorder(),
                            hintText: 'Email',
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
                        controller: senha,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock, color: Colors.black),
                            border: OutlineInputBorder(),
                            hintText: 'Senha',
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
                            'Criar'.toUpperCase(),
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
