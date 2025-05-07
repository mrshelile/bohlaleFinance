import 'package:uuid/uuid.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:bohlalefinance/models/database.dart';

class Deposit {
  final String id;
  final String name;
  final double amount;
  final String category;
  String date;

  Deposit({
    String? id,
    required this.name,
    required this.amount,
    required this.category,
    String? date,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category,
      'date': date,
    };
  }

  static Deposit fromMap(Map<String, dynamic> map) {
    return Deposit(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      category: map['category'],
      date: map['date'],
    );
  }

  Future<void> save() async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('deposits', toMap());
  }

  static Future<List<Deposit>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('deposits');
    return result.map((map) => Deposit.fromMap(map)).toList();
  }

  static Future<Deposit?> getById(String id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'deposits',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Deposit.fromMap(result.first);
    }
    return null;
  }

  Future<void> update() async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'deposits',
      toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'deposits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateDateById(String id, String newDate) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'deposits',
      {'date': newDate},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}