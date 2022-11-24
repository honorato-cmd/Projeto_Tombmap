import 'package:flutter/material.dart';
import 'package:tombmap/controllers/admin/admin.controller.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tombmap/models/admin.model.dart';
import 'package:tombmap/views/android/pages/admin/update.page.dart';

class OnlyAdmin extends StatefulWidget {
  const OnlyAdmin({Key? key}) : super(key: key);

  @override
  State<OnlyAdmin> createState() => _OnlyAdminState();
}

class _OnlyAdminState extends State<OnlyAdmin> {
final adminController = AdminController();
  Future<List<Map>>? admins;

@override
  void initState() {
    admins = adminController.readOnlyAdmin();
    super.initState();
  }

void lendoAdmin() async{
  final result = adminController.readOnlyAdmin();
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
        title: Text("Administrador Principal", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0))),
                                        backgroundColor: Colors.white,
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
                              ],
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),);
  }
}
