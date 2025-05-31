import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/rng.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();
  final password = 'a8F!kL@9zX#qP7wT&vR^3mN*oJ%5yU'; // Strong encryption password
  Future<Database> get database async {
    debugPrint('Getting database instance');
    if (_database != null) {
      debugPrint('Returning existing database instance');
      debugPrint('Database path: ${_database!.path}');
      return _database!;
    }
    _database = await _initDB('finance.db');
    debugPrint('Database initialized: ${_database!.path}');
    debugPrint('Database version: ${await _database!.getVersion()}');
    debugPrint('Database is open: ${_database!.isOpen}');
    
    return _database!;
  }
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'finance.db');
    await deleteDatabase(path);
    debugPrint('Database file deleted: $path');
    _database = null;
  }
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      password: password, // Set your encryption password here
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE assets (
        id TEXT PRIMARY KEY,
        assetName TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');
    debugPrint('Assets table created');
    await db.execute('''
      CREATE TABLE Loan (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        interest REAL NOT NULL,
        minAmount REAL NOT NULL,
        maxAmount REAL NOT NULL,
        paymentTerm TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
    debugPrint('Loan table created');
    await db.execute('''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        notes TEXT NOT NULL
      )
    ''');
    debugPrint('Expenses table created');
    await db.execute('''
      CREATE TABLE dept (
      id TEXT PRIMARY KEY,
      date TEXT NOT NULL,
      minAmount REAL NOT NULL,
      paymentTerm INTEGER NOT NULL,
      maxAmount REAL NOT NULL,
      name TEXT NOT NULL,
      interest REAL NOT NULL
      )
    ''');
    debugPrint('Depts table created');
    await db.execute('''
      CREATE TABLE taken_loans (
      id TEXT PRIMARY KEY,
      loanId TEXT NOT NULL,
      amount REAL NOT NULL,
      paymentTerm INTEGER NOT NULL,
      date TEXT NOT NULL,
      paid INTEGER NOT NULL, -- 0 = false, 1 = true
      FOREIGN KEY (loanId) REFERENCES Loan(id)
      )
    ''');
    debugPrint('Depts table created');
    // await db.execute('''
    //   CREATE TABLE income (
    //     id TEXT PRIMARY KEY,
    //     source TEXT NOT NULL,
    //     amount REAL NOT NULL,
    //     date TEXT NOT NULL
    //   )
    // ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
