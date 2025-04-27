import 'package:bohlalefinance/models/models.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
class Expense {
  final String id;
  final String name;
  final double amount;
  String date;
  final String category;
  final String notes;

  Expense({
    String? id,
    required this.name,
    required this.amount,
    String? date,
    required this.category,
    required this.notes,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date,
      'category': category,
      'notes': notes,
    };
  }

  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      date: map['date'],
      category: map['category'],
      notes: map['notes'],
    );
  }

  Future<void> save() async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('expenses', toMap());
  }

  static Future<List<Expense>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('expenses');
    return result.map((map) => Expense.fromMap(map)).toList();
  }

  static Future<Expense?> getById(String id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Expense.fromMap(result.first);
    }
    return null;
  }

  Future<void> update() async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'expenses',
      toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateDateById(String id, String newDate) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'expenses',
      {'date': newDate},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
