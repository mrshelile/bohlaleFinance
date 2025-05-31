import 'package:bohlalefinance/models/database.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class Dept {
  final String id;
  final String date;
  final double deptAmount;
  final int paymentTerm; // in months
  final String loanId; // reference to loans table
  final double payedAmount;
  final String name;
  final double interest;

  Dept({
    String? id,
    String? date,
    required this.name,
    required this.interest,
    required this.deptAmount,
    required this.paymentTerm,
    required this.loanId,
    required this.payedAmount,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      "interest":interest,
      'deptAmount': deptAmount,
      'paymentTerm': paymentTerm,
      'loanId': loanId,
      'payedAmount': payedAmount,
    };
  }

  static Dept fromMap(Map<String, dynamic> map) {
    return Dept(
      interest: map['interest'],
      name: map['name'],
      id: map['id'],
      date: map['date'],
      deptAmount: map['deptAmount'],
      paymentTerm: map['paymentTerm'],
      loanId: map['loanId'],
      payedAmount: map['payedAmount'],
    );
  }

  Future<void> save() async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('dept', toMap());
  }

  static Future<List<Dept>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('dept');
    return result.map((map) => Dept.fromMap(map)).toList();
  }

  static Future<Dept?> getById(String id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'dept',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Dept.fromMap(result.first);
    }
    return null;
  }

  Future<void> update() async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'dept',
      toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'dept',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}