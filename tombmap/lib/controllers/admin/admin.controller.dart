import 'package:sqflite/sqflite.dart';

import 'package:tombmap/models/admin.model.dart';

class AdminController {
  Future<Database> getDatabase() async {
    var path = await getDatabasesPath();
    path += 'teste.db';

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Admin (id INTEGER PRIMARY KEY autoincrement, nome TEXT, cpf TEXT, email TEXT unique, senha TEXT);'
          'INSERT INTO Admin Values ("Admin", "1000", "admin@admin.com", "123")');
    });
    

    return database;
  }

Future<Map> readSearch(String nome, String email) async {
    var database = await getDatabase();
    var adm = await database.rawQuery('SELECT id FROM Falecido WHERE nome = "$nome" and email = "$email" limit 1');
    Map results = {"id":0};
    await database.close();
    
    if (adm.isNotEmpty){
      results['id'] = adm[0]['id'];
    }
    return results;
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

  Future<List<Map>> readOnlyAdmin() async {
    var database = await getDatabase();
    List<Map> admins = await database.rawQuery('SELECT * FROM Admin WHERE id = 1');
    await database.close();
    return admins;
  }

  Future<List<Map>> read_Email_Senha_Admin(String email, String senha) async {
    var database = await getDatabase();
    List<Map> admins = await database.rawQuery(
        'SELECT email, senha FROM Admin WHERE email = "$email" AND senha = "$senha" AND id = 1');
    await database.close();
    return admins;
  }

  Future<List<Map>> readNotAdmin() async {
    var database = await getDatabase();
    List<Map> admins = await database.rawQuery('SELECT * FROM Admin WHERE id != 1');
    await database.close();
    return admins;
  }


  Future<Map> atualizacao(String email) async {
    var database = await getDatabase();
    var alteraremail = await database.rawQuery('SELECT * FROM Admin WHERE email = "$email"');
    Map results = {"id":0,"nome":"", "cpf":"", "email":"", "senha":""};
    await database.close();

    if (alteraremail.isNotEmpty){
      results['id'] = alteraremail[0]['id'];
      results['nome'] = alteraremail[0]['nome'];
      results['cpf'] = alteraremail[0]['cpf'];
      results['email'] = alteraremail[0]['email'];
      results['senha'] = alteraremail[0]['senha'];
    }
    return results;
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
