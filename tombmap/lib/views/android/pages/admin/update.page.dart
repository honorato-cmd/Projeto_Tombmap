// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:tombmap/controllers/admin/admin.controller.dart';
import 'package:tombmap/models/admin.model.dart';
import 'package:getwidget/getwidget.dart';

class UpdateAdministradorPage extends StatelessWidget {
  String id = "";
  var nome = TextEditingController();
  var cpf = TextEditingController();
  var email = TextEditingController();
  var senha = TextEditingController();

  UpdateAdministradorPage(admin) {
    id = admin["id"].toString();
    nome.text = admin["nome"];
    cpf.text = admin["cpf"];
    email.text = admin["email"];
    senha.text = admin["senha"];
  }

  void save(BuildContext context) async {
    var adminController = AdminController();

    CadastroAdmin admin = CadastroAdmin(
        id: id,
        nome: nome.text,
        cpf: cpf.text,
        email: email.text,
        senha: senha.text);

    await adminController.update(admin);

    Navigator.of(context).pushNamed("/cadastro");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Atualização ADM - ' + nome.text,
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
                          
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                        ),
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
                          icon: Icon(Icons.description_rounded, color: Colors.black),
                          border: OutlineInputBorder(),
                          hintText: 'CPF',
                          labelStyle: TextStyle(color: Colors.black),
                          
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                        ),
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
                          icon: Icon(Icons.email, color: Colors.black),
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                          labelStyle: TextStyle(color: Colors.black),
                          
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                        ),
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
                          
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                        ),

                        obscureText: false,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 250),
                      child: GFButton(
                                            shape: GFButtonShape.pills,
                                            color: Colors.black,
                                            onPressed: 
                                              () =>
                                                save(context),

                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                'Editar'.toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0),
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
