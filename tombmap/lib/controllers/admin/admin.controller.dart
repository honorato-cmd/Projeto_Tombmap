import 'package:sqflite/sqflite.dart';

import 'package:tombmap/models/admin.model.dart';

class AdminController {
  Future<Database> getDatabase() async {
    var path = await getDatabasesPath();
    path += 'teste.db';

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Admin (id INTEGER PRIMARY KEY autoincrement, nome TEXT, cpf TEXT, email TEXT, senha TEXT)');
    });

    return database;
  }

  Future<void> create(CadastroAdmin cadastroAdmin) async {
    var database = await getDatabase();
    await database.insert('Admin', cadastroAdmin.toMap());
    await database.close();
  }

  Future<List<Map>> read() async {
    var database = await getDatabase();
    List<Map> admins = await database.rawQuery('SELECT * FROM Admin');
    await database.close();
    return admins;
  }

  Future<List<Map>> read_Email_Senha(String email, String senha) async {
    var database = await getDatabase();
    List<Map> admins = await database.rawQuery(
        'SELECT email, senha FROM Admin WHERE email = "$email" AND senha = "$senha"');
    await database.close();
    return admins;
  }

  Future<void> update(CadastroAdmin cadastroAdmin) async {
    var database = await getDatabase();
    await database.update('Admin', cadastroAdmin.toMap(),
        where: 'id = ?', whereArgs: [cadastroAdmin.id]);
    await database.close();
  }

  Future<void> delete(cadastroAdmin) async {
    var database = await getDatabase();
    await database
        .delete('Admin', where: 'id = ?', whereArgs: [cadastroAdmin["id"]]);
    await database.close();
  }

  /*Future<List<Map>> searchResult(String userSearch) async {
    var database = await getDatabase();
    List<Map> admin = await database
        .rawQuery('SELECT * FROM Admin WHERE nome like "%$userSearch%"');
    await database.close();
    return admin;
  }*/
}
