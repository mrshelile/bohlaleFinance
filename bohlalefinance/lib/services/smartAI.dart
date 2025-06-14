// ignore_for_file: unnecessary_type_check

import 'package:flutter/material.dart';

import '../boot/boot.dart';
import '../models/Assets.dart';
import '../models/Deposits.dart';
import '../models/Loans.dart';
import '../models/dept.dart';
import '../models/expenses.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SmartAIcallService {
  late UserProfile userProfile;
  late List<LoanOption> loanOptions;
  late List<LoanRecommendation> loanRecommendations;

  SmartAIcallService();

  /// Factory method to create and initialize the service asynchronously
  static Future<SmartAIcallService> create() async {
    final service = SmartAIcallService();
    await service._gatherUserProfile();
    service.loanOptions = await _getLoanOptions();
    return service;
  }

  /// Gathers user profile data asynchronously from models
  Future<void> _gatherUserProfile() async {
    final assets = await Asset.getAll();
    final expenses = await Expense.getAll();
    
    final loans = await Dept.getAllTakenLoans(); // taken loans => unpaid + paid

    // Calculate monthly income from deposits (sum all deposit amounts for the current month)
    final now = DateTime.now();

  // Calculate total assets (sum of assets with type 'Other income')
  final totalAssets = assets
      .where((a) => a.type == 'Other income')
      .fold<int>(0, (sum, a) => sum + (a.amount is num ? a.amount.toInt() : int.tryParse(a.amount.toString()) ?? 0));

  // Calculate monthly income (sum of assets with type 'Monthly salary')
  final monthlyIncome = assets
      .where((a) => a.type == 'Monthly salary')
      .fold<int>(0, (sum, a) => sum + (a.amount is num ? a.amount.toInt() : int.tryParse(a.amount.toString()) ?? 0));
   debugPrint("assets: ${assets.first.toMap().toString()}");
   debugPrint("monthly salary: ${monthlyIncome}");
  // Calculate annual income
  final annualIncome = monthlyIncome * 12;
    // Calculate total expenses
    final totalExpenses = expenses.fold<int>(0, (sum, e) => sum + (e.amount is num ? e.amount.toInt() : int.tryParse(e.amount.toString()) ?? 0));

    // Calculate total taken loans (sum of 'amount' field for all loans)
    final totalTakenLoans = loans.fold<int>(0, (sum, d) => sum + (d['amount'] is num ? (d['amount'] as num).toInt() : int.tryParse(d['amount'].toString()) ?? 0));

    // Count only loans where 'paid' == false as active
    final activeLoans = loans.where((d) => d['paid'] == false).length;

    // Calculate average interest (use only loans with a valid 'interest' field)
    final interestList = loans
      .where((l) => l['interest'] != null)
      .map((l) {
        double value = l['interest'] is num
          ? (l['interest'] as num).toDouble()
          : double.tryParse(l['interest'].toString()) ?? 0.0;
        // Standardize: if value > 1, assume it's a percentage and divide by 100
        return value > 1 ? value / 100 : value;
      })
      .toList();
    final avgInterest = interestList.isNotEmpty
      ? interestList.reduce((a, b) => a + b) / interestList.length
      : 0;

    // Number of loans
    final nLoans = loans.length;

    userProfile = UserProfile(
      monthlyIncome: monthlyIncome,
      totalAssets: totalAssets,
      totalExpenses: totalExpenses,
      totalTakenLoans: totalTakenLoans,
      activeLoans: activeLoans,
      avgInterest: avgInterest.toDouble(),
      nLoans: nLoans,
       annualIncome: annualIncome,
    );
    debugPrint(userProfile.toMap().toString());
  }

  /// Returns loan options dynamically from Dept.getAll()
  static Future<List<LoanOption>> _getLoanOptions() async {
    final loans = await Dept.getAll();
    
    final output= loans.map<LoanOption>((loan) {
      return LoanOption(
        nameOfCompany: loan.name,
        interest: (() {
          double value = loan.interest;
          // If value > 1, assume it's a percentage and divide by 100
          if (value > 1) value = value / 100;
          // Clamp between 0 and 1
          return value.clamp(0.0, 1.0);
        })(),
        minAmount: loan.minAmount,
        maxAmount: loan.maxAmount,
        paymentTerm: loan.paymentTerm ,
      );
    }).toList();
    debugPrint(output.first.toMap().toString());
    return output;
  }

  /// Builds the API request body as per the required format
  Map<String, dynamic> _buildRequestBody() {
    return {
      'user_profile': userProfile.toMap(),
      'loan_options': loanOptions.map((o) => o.toMap()).toList(),
    };
  }

  /// Calls the AI recommendation API and parses the response
  Future<LoanRecommendationsResponse> getLoanRecommendation() async {
    final Uri recommendAllUri = Uri.parse(recommend_all);
    final body = jsonEncode(_buildRequestBody());

    final response = await http.post(
      recommendAllUri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final recommendationsResponse = LoanRecommendationsResponse.fromMap(data);
      loanRecommendations = recommendationsResponse.recommendations;
      return recommendationsResponse;
    } else {
      throw Exception('Failed to get recommendations: ${response.body}');
    }
  }
}

class LoanRecommendation {
  final String nameOfCompany;
  final double interest;
  final double minAmount;
  final double maxAmount;
  final int paymentTerm;
  final double predictedAmount;
  final int predictedTerm;
  final double monthlyPayment;

  LoanRecommendation({
    required this.nameOfCompany,
    required this.interest,
    required this.minAmount,
    required this.maxAmount,
    required this.paymentTerm,
    required this.predictedAmount,
    required this.predictedTerm,
    required this.monthlyPayment,
  });

  factory LoanRecommendation.fromMap(Map<String, dynamic> map) {
    return LoanRecommendation(
      nameOfCompany: map['name_of_company'],
      interest: map['interest'].toDouble(),
      minAmount: map['min_amount'].toDouble(),
      maxAmount: map['max_amount'].toDouble(),
      paymentTerm: map['payment_term'],
      predictedAmount: map['predicted_amount'].toDouble(),
      predictedTerm: map['predicted_term'],
      monthlyPayment: map['monthly_payment'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name_of_company': nameOfCompany,
      'interest': interest,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'payment_term': paymentTerm,
      'predicted_amount': predictedAmount,
      'predicted_term': predictedTerm,
      'monthly_payment': monthlyPayment,
    };
  }
}

class LoanRecommendationsResponse {
  final List<LoanRecommendation> recommendations;
  final String message;

  LoanRecommendationsResponse({
    required this.recommendations,
    required this.message,
  });

  factory LoanRecommendationsResponse.fromMap(Map<String, dynamic> map) {
    return LoanRecommendationsResponse(
      recommendations: List<LoanRecommendation>.from(
        (map['recommendations'] as List)
            .map((item) => LoanRecommendation.fromMap(item)),
      ),
      message: map['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recommendations': recommendations.map((r) => r.toMap()).toList(),
      'message': message,
    };
  }
}
class LoanOption {
  final String nameOfCompany;
  final double interest;
  final double minAmount;
  final double maxAmount;
  final int paymentTerm;

  LoanOption({
    required this.nameOfCompany,
    required this.interest,
    required this.minAmount,
    required this.maxAmount,
    required this.paymentTerm,
  });

  factory LoanOption.fromMap(Map<String, dynamic> map) {
    return LoanOption(
      nameOfCompany: map['name_of_company'],
      interest: map['interest'].toDouble(),
      minAmount: map['min_amount'],
      maxAmount: map['max_amount'],
      paymentTerm: map['payment_term'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name_of_company': nameOfCompany,
      'interest': interest,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'payment_term': paymentTerm,
    };
  }
}

class UserProfile {
  final int monthlyIncome;
  final int annualIncome;
  final int totalAssets;
  final int totalExpenses;
  final int totalTakenLoans;
  final int activeLoans;
  final double avgInterest;
  final int nLoans;

  UserProfile({
    required this.monthlyIncome,
    required this.annualIncome,
    required this.totalAssets,
    required this.totalExpenses,
    required this.totalTakenLoans,
    required this.activeLoans,
    required this.avgInterest,
    required this.nLoans,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      monthlyIncome: map['monthly_income'],
      annualIncome: map['annual_income'],
      totalAssets: map['total_assets'],
      totalExpenses: map['total_expenses'],
      totalTakenLoans: map['total_taken_loans'],
      activeLoans: map['active_loans'],
      avgInterest: map['avg_interest'].toDouble(),
      nLoans: map['n_loans'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monthly_income': monthlyIncome,
      'annual_income': annualIncome,
      'total_assets': totalAssets,
      'total_expenses': totalExpenses,
      'total_taken_loans': totalTakenLoans,
      'active_loans': activeLoans,
      'avg_interest': avgInterest,
      'n_loans': nLoans,
    };
  }
}