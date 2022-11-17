// ignore_for_file: prefer_const_constructors

import 'package:tombmap/controllers/admin/falecido.controller.dart';
import 'package:flutter/material.dart';
import 'package:tombmap/models/falecido.model.dart';
import 'package:tombmap/views/android/pages/admin/update.falecido.dart';

class ListaFalecidos extends StatefulWidget {
  const ListaFalecidos({Key? key}) : super(key: key);

  @override
  State<ListaFalecidos> createState() => _ListaFalecidosState();
}

class _ListaFalecidosState extends State<ListaFalecidos> {
  final falecidoController = FalecidoController();
  //TextEditingController _searchTextController = TextEditingController();

  Future<List<Map>>? falecidos;

  @override
  void initState() {
    falecidos = falecidoController.read();
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
      falecidos = falecidoController.read();
    });
  }

  void updateFalecido(CadastroFalecidos falecidos) async {
    await falecidoController.update(falecidos);
    updateState();
  }

  Future<void> deleteFalecido(falecidos) async {
    await falecidoController.delete(falecidos);
    Navigator.of(context).pop();
    updateState(); //NOTE: OK.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista Falecidos"),
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
                future: falecidos,
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
                        var falecidos = snapshot.data!;
                        final falecido = falecidos[index];

                        return ListTile(
                          title: Text('Nome: ${falecido['nome']}'),
                          subtitle: Text('Latitude: ${falecido['latitude']}'),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Editar Falecido'),
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
                                                          UpdateFalecidoPage(
                                                              falecido)));
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
                                        title: Text('Excluir Falecido'),
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
                                                await deleteFalecido(falecido),
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
