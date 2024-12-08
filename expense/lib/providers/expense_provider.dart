//Author:Ansh Patel
//Description: This class create a list for expenses where we can add new expenses and notifies listners about changes.
import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class ExpensesProvider with ChangeNotifier {
  final List<Expense> _expenses = []; //list of expenses

  List<Expense> get expenses => _expenses; // getter for read only access
  //method to add new expenses
  void addExpense(Expense expense) async {
    _expenses.add(expense);
    
    notifyListeners();
    // Save the updated list to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final expenseList = _expenses.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('expenses', expenseList);
  }
}
