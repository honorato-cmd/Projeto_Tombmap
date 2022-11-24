import 'package:sqflite/sqflite.dart';

import 'package:tombmap/models/falecido.model.dart';

class FalecidoController {
  Future<Database> getDatabase() async {
    var path = await getDatabasesPath();
    path += 'falecido.db';

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Falecido (id INTEGER PRIMARY KEY autoincrement, nome TEXT, latitude TEXT, longitude TEXT, lapide TEXT)');
    });

    return database;
  }

  Future<void> create(CadastroFalecidos cadastroFalecidos) async {
    var database = await getDatabase();
    await database.insert('Falecido', cadastroFalecidos.toMap());
    await database.close();
  }

  Future<List<Map>> read() async {
    var database = await getDatabase();
    List<Map> falecidos = await database.rawQuery('SELECT * FROM Falecido');
    await database.close();
    return falecidos;
  }

  Future<Map> readSearch(String nome, String lapide) async {
    var database = await getDatabase();
    var falecidos = await database.rawQuery('SELECT latitude, longitude FROM Falecido WHERE nome = "$nome" and lapide = "$lapide" limit 1');
    Map results = {"longitude":0, "latitude":0};
    await database.close();
    
    if (falecidos.isNotEmpty){
      results['longitude'] = falecidos[0]['longitude'];
      results['latitude'] =  falecidos[0]['latitude'];
    }
    return results;
  }

  Future<void> update(CadastroFalecidos cadastroFalecidos) async {
    var database = await getDatabase();
    await database.update('Falecido', cadastroFalecidos.toMap(),
        where: 'id = ?', whereArgs: [cadastroFalecidos.id]);
    await database.close();
  }

  Future<void> delete(cadastroFalecidos) async {
    var database = await getDatabase();
    await database.delete('Falecido',
        where: 'id = ?', whereArgs: [cadastroFalecidos["id"]]);
    await database.close();
  }

  Future<List<Map>> searchResult(String userSearch) async {
    var database = await getDatabase();
    List<Map> falecidos = await database
        .rawQuery('SELECT * FROM Falecido WHERE nome like "%$userSearch%"');
    await database.close();
    return falecidos;
  }
}
