import 'package:bohlalefinance/models/database.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class Dept {
  final String id;
  final String date;
  final int paymentTerm; // in months
  final double minAmount;
  final double maxAmount;
  final String name;
  final double interest;

  Dept({
    String? id,
    String? date,
    required this.name,
    required this.interest,
    required this.minAmount,
    required this.maxAmount,
    required this.paymentTerm,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      "interest":interest,
      'paymentTerm': paymentTerm,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
    };
  }

  static Dept fromMap(Map<String, dynamic> map) {
    return Dept(
      interest: map['interest'],
      name: map['name'],
      id: map['id'],
      date: map['date'],
      paymentTerm: map['paymentTerm'],
      minAmount: map['minAmount'],
      maxAmount: map['maxAmount'],
    );
  }

  Future<void> save() async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('dept', toMap());
  }
  // Function to create 10 random loan records with random values and different dates from Jan until now
  static Future<void> createRandomLoans() async {
    final db = await DatabaseHelper.instance.database;
    final uuid = const Uuid();
    final now = DateTime.now();
    final random = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < 10; i++) {
      // Generate a random date from Jan 1st to now
      final start = DateTime(now.year, 1, 1).millisecondsSinceEpoch;
      final end = now.millisecondsSinceEpoch;
      final randomMillis = start + (DateTime.now().microsecondsSinceEpoch * (i + 1)) % (end - start);
      final randomDate = DateTime.fromMillisecondsSinceEpoch(randomMillis);

      // Generate random values
      final minAmount = 1000 + (i * 100) + (random % 500);
      final maxAmount = minAmount + 1000 + (random % 2000);
      final interest = 5 + (i * 0.5) + ((random % 100) / 100);
      final paymentTerm = 6 + (i % 12);
      final name = 'Loan ${String.fromCharCode(65 + i)}';

      final dept = Dept(
        name: name,
        interest: interest,
        minAmount: minAmount.toDouble(),
        maxAmount: maxAmount.toDouble(),
        paymentTerm: paymentTerm,
        date: randomDate.toIso8601String(),
      );
      await db.insert('dept', dept.toMap());
    }
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
    required double amount,
    required int paymentTerm,
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

  // Function to generate random taken loans (paid and unpaid) using data from loan table
  static Future<void> generateRandomTakenLoans() async {
    final db = await DatabaseHelper.instance.database;
    final loans = await Dept.getAll();
    if (loans.isEmpty) return;

    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    final months = now.month;
    final random = DateTime.now().millisecondsSinceEpoch;

    for (int m = 0; m < months; m++) {
      final monthStart = DateTime(now.year, m + 1, 1);
      final monthEnd = (m == months - 1)
          ? now
          : DateTime(now.year, m + 2, 1).subtract(const Duration(days: 1));
      for (int i = 0; i < 3; i++) {
        // Pick a random loan
        final loan = loans[(random + m * 10 + i) % loans.length];

        // Generate a random amount between minAmount and maxAmount + interest
        final maxWithInterest = loan.maxAmount + (loan.maxAmount * loan.interest / 100);
        final minWithInterest = loan.minAmount;
        final amount = minWithInterest +
            ((random + i * 100 + m * 50) % (maxWithInterest - minWithInterest + 1)).toDouble();

        // Generate a random payment term (not exceeding the loan's paymentTerm)
        final paymentTerm = loan.paymentTerm - ((random + i + m) % loan.paymentTerm);

        // Generate a random date within the month
        final daysInMonth = monthEnd.difference(monthStart).inDays + 1;
        final randomDay = (random + i * 7 + m * 3) % daysInMonth;
        final date = monthStart.add(Duration(days: randomDay)).toIso8601String();

        // Randomly decide if paid or not
        final paid = ((random + i + m) % 2 == 0) ? 1 : 0;
        debugPrint("working");
        await db.insert('taken_loans', {
          'id': const Uuid().v4(),
          'loanId': loan.id,
          'amount': amount,
          'paymentTerm': paymentTerm,
          'date': date,
          'paid': paid,
        });
        debugPrint('Inserted taken loan: $amount for ${loan.name} on $date');
      }
    }
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
    // Join taken_loans with dept to get dept info (name, interest, etc)
    final result = await db.rawQuery('''
      SELECT 
      taken_loans.id as id,
      taken_loans.loanId as loanId,
      taken_loans.amount as amount,
      taken_loans.paymentTerm as paymentTerm,
      taken_loans.date as date,
      taken_loans.paid as paid,
      dept.name as name,
      dept.interest as interest,
      dept.minAmount as minAmount,
      dept.maxAmount as maxAmount
      FROM taken_loans
      LEFT JOIN dept ON taken_loans.loanId = dept.id
    ''');

    return result.map((map) {
      return {
      'id': map['id'],
      'loanId': map['loanId'],
      'amount': map['amount'],
      'paymentTerm': map['paymentTerm'],
      'date': map['date'],
      'paid': map['paid'] == 1,
      'name': map['name'],
      'interest': map['interest'],
      'minAmount': map['minAmount'],
      'maxAmount': map['maxAmount'],
      };
    }).toList();
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
      // Ensure the returned map matches the table structure and types
      final map = result.first;
      return {
        'id': map['id'],
        'loanId': map['loanId'],
        'amount': map['amount'],
        'paymentTerm': map['paymentTerm'],
        'date': map['date'],
        'paid': map['paid'] == 1, // convert to bool
      };
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