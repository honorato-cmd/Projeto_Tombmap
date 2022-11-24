// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:tombmap/controllers/admin/admin.controller.dart';
import 'package:tombmap/models/admin.model.dart';
import 'package:getwidget/getwidget.dart';

class UpdateEmail extends StatelessWidget {
  String id = "";
  var nome = TextEditingController();
  var cpf = TextEditingController();
  var email = TextEditingController();
  var senha = TextEditingController();

  UpdateEmail(results) {
    id = results["id"].toString();
    nome.text = results["nome"];
    cpf.text = results["cpf"];
    email.text = results["email"];
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
    Navigator.of(context).pushNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bem vindo de volta, ' + nome.text + '!',
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
              Navigator.of(context).pop();
            }),
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
                        controller: senha,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.password,
                              color: Colors.black,
                            ),
                            
                            border: OutlineInputBorder(),
                            hintText: 'Senha',
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
                        onPressed: 
                          () => save(context),

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
