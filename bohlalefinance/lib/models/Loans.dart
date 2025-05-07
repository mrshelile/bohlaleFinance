import 'package:bohlalefinance/models/database.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
class Loan {
  final String id;
  final String name;
  final double interest;
  final double minAmount;
  final double maxAmount;
  final int paymentTerm; // in months
  String date;

  Loan({
    String? id,
    required this.name,
    required this.interest,
    required this.minAmount,
    required this.maxAmount,
    required this.paymentTerm,
    String? date,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'interest': interest,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
      'paymentTerm': paymentTerm,
      'date': date,
    };
  }

  static Loan fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['id'],
      name: map['name'],
      interest: map['interest'],
      minAmount: map['minAmount'],
      maxAmount: map['maxAmount'],
      paymentTerm: map['paymentTerm'],
      date: map['date'],
    );
  }

  Future<void> save() async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('loans', toMap());
  }

  static Future<List<Loan>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('loans');
    return result.map((map) => Loan.fromMap(map)).toList();
  }

  static Future<Loan?> getById(String id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'loans',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Loan.fromMap(result.first);
    }
    return null;
  }

  Future<void> update() async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'loans',
      toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'loans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateDateById(String id, String newDate) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'loans',
      {'date': newDate},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
