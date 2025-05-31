import 'package:bohlalefinance/models/database.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class Dept {
  final String id;
  final String date;
  final double deptAmount;
  final int paymentTerm; // in months

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
  // Static function to take a loan and insert into taken_loans table
  static Future<void> takeLoan({
    required String loanId,
    required String name,
    required double amount,
    required int paymentTerm,
    required double recommendedAmount,
    required int recommendedTerm,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final id = const Uuid().v4();
    final date = DateTime.now().toIso8601String();
    await db.insert('taken_loans', {
      'id': id,
      'loanId': loanId, // ensure loanId is included for the foreign key
      'amount': amount,
      'paymentTerm': paymentTerm,
      'date': date,
      'paid': 0,
    });
  }

  // Static function to update the paid status of a taken loan
  static Future<void> updatePaidStatus({
    required String takenLoanId,
    required bool paid,
  }) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'taken_loans',
      {'paid': paid ? 1 : 0},
      where: 'id = ?',
      whereArgs: [takenLoanId],
    );
  }

  // Static function to get all taken loans
  static Future<List<Map<String, dynamic>>> getAllTakenLoans() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query('taken_loans');
  }

  // Static function to get a taken loan by id and return as a Map (toMap)
  static Future<Map<String, dynamic>?> getTakenLoanById({
    required String id,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'taken_loans',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first; // Already a Map<String, dynamic>
    }
    return null;
  }

  // Static function to get a taken loan by id and return as JSON (toJson)
  static Future<String?> getTakenLoanByIdAsJson({
    required String id,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'taken_loans',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first.toString(); // Or use jsonEncode(result.first) if you import 'dart:convert'
    }
    return null;
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