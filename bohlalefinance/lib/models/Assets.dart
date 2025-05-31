import 'package:bohlalefinance/models/database.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/rng.dart';

class Asset {
  final String id;
  final String assetName;
  final double amount;
  final String date;
  final String type;
  Asset({
    String? id,
    required this.assetName,
    required this.amount,
    String? date,
    required this.type,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now().toIso8601String();

  static Future<void> updateDateById(int id, String newDate) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'expenses',
      {'date': newDate},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetName': assetName,
      'amount': amount,
      'date': date,
      'type': type,
    };
  }

  static Asset fromMap(Map<String, dynamic> map) {
    return Asset(
      
      id: map['id'],
      assetName: map['assetName'],
      amount: map['amount'],
      date: map['date'],
      type: map['type'],
    );
  }
static Future<double> getTotalAmount() async {
  final db = await DatabaseHelper.instance.database;
  final result = await db.rawQuery('SELECT SUM(amount) as total FROM assets');
  if (result.isNotEmpty && result.first['total'] != null) {
    return (result.first['total'] as num).toDouble();
  }
  return 0.0;
}
  Future<void> save() async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('assets', toMap());
  }

  static Future<List<Asset>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('assets');
    if (result.isEmpty) {
      return [];
    }
    // Ensure 'type' is present in each map, or provide a default value if missing
    return result.map((map) {
      final assetMap = Map<String, dynamic>.from(map);
      assetMap['type'] ??= '';
      return Asset.fromMap(assetMap);
    }).toList();
  }

  static Future<Asset?> getById(String id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'assets',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Asset.fromMap(result.first);
    }
    return null;
  }

  Future<void> update() async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'assets',
      toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'assets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}