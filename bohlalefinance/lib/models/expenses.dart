import 'package:bohlalefinance/models/database.dart';
import 'package:uuid/uuid.dart';

class Expense {
  final String id;
  final String name;
  final double amount;
  final String date;
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
  static Future<double> getTotalAmount() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery('SELECT SUM(amount) as total FROM expenses');
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }
  static Expense fromMap(Map<String, dynamic> map) {
    // Defensive mapping with default values
    return Expense(
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      amount: (map['amount'] is int)
          ? (map['amount'] as int).toDouble()
          : (map['amount'] ?? 0.0),
      date: map['date'] ?? DateTime.now().toIso8601String(),
      category: map['category'] ?? '',
      notes: map['notes'] ?? '',
    );
  }

  Future<void> save() async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('expenses', toMap());
  }

  static Future<List<Expense>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('expenses');
    if (result.isEmpty) return [];
    return result.map((map) => Expense.fromMap(Map<String, dynamic>.from(map))).toList();
  }

  static Future<Expense?> getById(String id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Expense.fromMap(Map<String, dynamic>.from(result.first));
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
