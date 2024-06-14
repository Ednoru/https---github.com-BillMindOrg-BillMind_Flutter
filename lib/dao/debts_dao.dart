import 'package:nav_bar/database/database.dart';
import 'package:nav_bar/models/debts.dart';

class DebtsDao {
  static const String tableDebt = 'debt';

  Future<int> insertDebt(Debts debt) async {
    final db = await DatabaseHelper.openDB();
    return await db.insert(tableDebt, debt.toJson());
  }

  Future<List<Debts>> getDebts() async {
    final db = await DatabaseHelper.openDB();
    final List<Map<String, dynamic>> maps = await db.query(tableDebt);

    return List.generate(maps.length, (i) {
      return Debts.fromJson(maps[i]);
    });
  }

  Future<int> updateDebt(Debts debt) async {
    final db = await DatabaseHelper.openDB();
    return await db.update(
      tableDebt,
      debt.toJson(),
      where: 'id = ?',
      whereArgs: [debt.id],
    );
  }

  Future<int> deleteDebt(int id) async {
    final db = await DatabaseHelper.openDB();
    return await db.delete(
      tableDebt,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
