// ignore_for_file: prefer_const_constructors

import 'package:tombmap/controllers/admin/admin.controller.dart';
import 'package:flutter/material.dart';
import 'package:tombmap/models/admin.model.dart';
import 'package:tombmap/views/android/pages/admin/update.page.dart';

class ListaAdm extends StatefulWidget {
  const ListaAdm({Key? key}) : super(key: key);

  @override
  State<ListaAdm> createState() => _ListaAdmState();
}

class _ListaAdmState extends State<ListaAdm> {
  final adminController = AdminController();
  //TextEditingController _searchTextController = TextEditingController();

  Future<List<Map>>? admins;

  @override
  void initState() {
    admins = adminController.read();
    super.initState();
  }

  /*
  void searchtState() {
    setState(() {
      admins = adminController.searchResult(_searchTextController.text);
    });
  }
  */

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
        title: Text("Lista ADM"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed('/localizador');
          },
        ),
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
                                        title: Text('Editar Administrador'),
                                        content: Text('Deseja Editar?'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Não'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateAdministradorPage(
                                                              admin)));
                                            },
                                            child: Text('Sim'),
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
                                        title: Text('Excluir Administrador'),
                                        content: Text('Deseja Excluir?'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Não'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async =>
                                                await deleteAdmin(admin),
                                            child: Text('Sim'),
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
