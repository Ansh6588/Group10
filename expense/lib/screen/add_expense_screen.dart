//Author: Ansh Patel 
//Description: This screen provides a form to add a new expense
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/expense_provider.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<String> _friends = ["Jerome", "Ansh","Meet"];//List of friends
  String? _paidBy;  // Track who paid for the expense 
  List<String> _selectedFriends = [];  // Track who the expense is split between

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: SingleChildScrollView(  // Wrap content in SingleChildScrollView
      //Prevent overflow when the keyboard is shown
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              //Input field for expense amount
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            //Input field for expense description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),

            // Dropdown to select who paid for the expense
            DropdownButtonFormField<String>(
              value: _paidBy,
              decoration: const InputDecoration(labelText: "Paid By"),
              items: [
                DropdownMenuItem(value: "Jerome", child: const Text("Jerome")),
                DropdownMenuItem(value: "Ansh", child: const Text("Ansh")),
                DropdownMenuItem(value: "Meet", child: const Text("Meet")),
              ],
              onChanged: (value) {
                setState(() {
                  _paidBy = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // check boxes to select who shares the expense
            Text("Split Between:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ..._friends.map((friend) {
              return CheckboxListTile(
                title: Text(friend),
                value: _selectedFriends.contains(friend),
                onChanged: (isSelected) {
                  setState(() {
                    if (isSelected == true) {
                      _selectedFriends.add(friend);
                    } else {
                      _selectedFriends.remove(friend);
                    }
                  });
                },
              );
            }).toList(),

            const SizedBox(height: 20),
             // Button to save the expense
            ElevatedButton(
              onPressed: () => _submitExpense(context),
              child: const Text("Save Expense"),
            ),
          ],
        ),
      ),
    );
  }
  //validations
  void _submitExpense(BuildContext context) async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final description = _descriptionController.text;

    if (amount <= 0 || description.isEmpty || _paidBy == null || _selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill out all fields")),
      );
      return;
    }

    final newExpense = Expense(
      id: DateTime.now().toString(),
      amount: amount,
      description: description,
      paidBy: _paidBy ?? "You",
      date: _selectedDate,
      splitBetween: _selectedFriends,  // Pass the selected friends here
    );
    final prefs = await SharedPreferences.getInstance();
    final expenses = prefs.getStringList('expenses') ?? []; // Retrieve existing expenses
    expenses.add(jsonEncode(newExpense.toJson())); // Convert expense to JSON
    await prefs.setStringList('expenses', expenses); // Save updated expenses

    //Adding expense to the provider 
    Provider.of<ExpensesProvider>(context, listen: false).addExpense(newExpense);
    // this will navigate back to the previous screen
    Navigator.of(context).pop();
  }
}
