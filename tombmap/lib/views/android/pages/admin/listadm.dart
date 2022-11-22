// ignore_for_file: prefer_const_constructors

import 'package:tombmap/controllers/admin/admin.controller.dart';
import 'package:flutter/material.dart';
import 'package:tombmap/models/admin.model.dart';
import 'package:tombmap/views/android/pages/admin/update.page.dart';
import 'package:getwidget/getwidget.dart';

class ListaAdm extends StatefulWidget {
  const ListaAdm({Key? key}) : super(key: key);

  @override
  State<ListaAdm> createState() => _ListaAdmState();
}

class _ListaAdmState extends State<ListaAdm> {
  var email = TextEditingController();
  var senha = TextEditingController();
  final adminController = AdminController();
  //TextEditingController _searchTextController = TextEditingController();

  Future<List<Map>>? admins;

  @override
  void initState() {
    admins = adminController.readNotAdmin();
    super.initState();
  }

  /*
  void searchtState() {
    setState(() {
      admins = adminController.searchResult(_searchTextController.text);
    });
  }
  */
  void lendoAdmin() async {
    final result =
        await adminController.read_Email_Senha_Admin(email.text, senha.text);
    print(email);
    print(senha);
    if (result.isNotEmpty) {
      Navigator.of(context).pushNamed('/onlyadmin');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          backgroundColor: Colors.grey,
          title: Text('Acesso Negado'),
          content:
              Text('Apenas o usuário Admin principal pode acessar esta área!'),
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
  }

  void VerificarAdmin() async {
    final result = adminController.readOnlyAdmin();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/onlyadmin', (route) => false);
  }

  void updateState() {
    setState(() {
      admins = adminController.read();
    });
  }

  void updateAdmin(CadastroAdmin admin) async {
    await adminController.update(admin);
    updateState();
  }

  Future<void> deleteAdmin(admin) async {
    await adminController.delete(admin);
    Navigator.of(context).pop();
    updateState(); //NOTE: OK.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admins",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushNamed('/localizador');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.lock, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  backgroundColor: Colors.grey,
                  title: Text('Área restrita'),
                  content: TextFormField(
                    cursorColor: Colors.black,
                    controller: email,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        icon: Icon(Icons.person, color: Colors.black),
                        border: OutlineInputBorder(),
                        hintText: 'E-mail do administrador principal',
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
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            backgroundColor: Colors.grey,
                            title: Text('Área restrita'),
                            content: TextFormField(
                              cursorColor: Colors.black,
                              controller: senha,
                              obscureText: true,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white70,
                                  icon: Icon(Icons.person, color: Colors.black),
                                  border: OutlineInputBorder(),
                                  hintText: 'Senha do administrador principal',
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black))),
                            ),
                            actions: [
                              GFButton(
                                shape: GFButtonShape.pills,
                                color: Colors.black,
                                onPressed: () {
                                  lendoAdmin();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    'Prosseguir'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
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
                ),
              );
            },
          ),
          TextButton(
            child: Text(
              "Adicionar",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/cadastroadministrador');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<dynamic, dynamic>>>(
                future: admins,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    // ignore: curly_braces_in_flow_control_structures
                    return Center(
                      child: CircularProgressIndicator(), // mensagem circular
                    );

                  if (snapshot.hasError)
                    return Text(snapshot.error!.toString());

                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        var admins = snapshot.data!;
                        final admin = admins[index];

                        return ListTile(
                          title: Text('Nome: ${admin['nome']}'),
                          subtitle: Text('Email: ${admin['email']}'),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0))),
                                        backgroundColor: Colors.grey,
                                        title: Text('Editar Administrador'),
                                        content: Text('Deseja Editar?'),
                                        actions: [
                                          GFButton(
                                            shape: GFButtonShape.pills,
                                            color: Colors.black,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                'Não'.toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0),
                                              ),
                                            ),
                                          ),
                                          GFButton(
                                            shape: GFButtonShape.pills,
                                            color: Colors.black,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateAdministradorPage(
                                                              admin)));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                'Sim'.toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                  color: Colors.orange,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0))),
                                        backgroundColor: Colors.grey,
                                        title: Text('Excluir Administrador'),
                                        content: Text('Deseja Excluir?'),
                                        actions: [
                                          GFButton(
                                            shape: GFButtonShape.pills,
                                            color: Colors.black,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                'Não'.toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0),
                                              ),
                                            ),
                                          ),
                                         GFButton(
                                            shape: GFButtonShape.pills,
                                            color: Colors.black,
                                            onPressed: 
                                              () async =>
                                                await deleteAdmin(admin),

                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                'Sim'.toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
