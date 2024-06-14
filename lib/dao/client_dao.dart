import 'package:nav_bar/database/database.dart';
import 'package:nav_bar/models/client.dart';

class ClientDao {
  static const String tableClient = 'client';

  Future<int> insertClient(Client client) async {
    final db = await DatabaseHelper.openDB();
    return await db.insert(tableClient, client.toJson());
  }

  Future<List<Client>> getClients() async {
    final db = await DatabaseHelper.openDB();
    final List<Map<String, dynamic>> maps = await db.query(tableClient);

    return List.generate(maps.length, (i) {
      return Client.fromJson(maps[i]);
    });
  }

  Future<int> updateClient(Client client) async {
    final db = await DatabaseHelper.openDB();
    return await db.update(
      tableClient,
      client.toJson(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> deleteClient(int id) async {
    final db = await DatabaseHelper.openDB();
    return await db.delete(
      tableClient,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
