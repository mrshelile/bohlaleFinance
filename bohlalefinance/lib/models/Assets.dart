import 'package:bohlalefinance/models/database.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/rng.dart';

class Asset {
  final String id;
  final String assetName;
  final double amount;
  final String date;

  Asset({
    String? id,
    required this.assetName,
    required this.amount,
    String? date,
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
    };
  }

  static Asset fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'],
      assetName: map['assetName'],
      amount: map['amount'],
      date: map['date'],
    );
  }

  Future<void> save() async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('assets', toMap());
  }

  static Future<List<Asset>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('assets');
    return result.map((map) => Asset.fromMap(map)).toList();
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