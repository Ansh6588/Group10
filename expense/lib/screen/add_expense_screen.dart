import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  final List<String> _friends = ["Jerome", "Ansh","Meet"];
  String? _paidBy;  // Track who paid for the expense (only one selection)
  List<String> _selectedFriends = [];  // Track who the expense is split between

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: SingleChildScrollView(  // Wrap content in SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),

            // Paid By: Single selection dropdown
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

            // Split Between: Multi-select list (checkboxes)
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

            ElevatedButton(
              onPressed: () => _submitExpense(context),
              child: const Text("Save Expense"),
            ),
          ],
        ),
      ),
    );
  }

  void _submitExpense(BuildContext context) {
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

    Provider.of<ExpensesProvider>(context, listen: false).addExpense(newExpense);

    Navigator.of(context).pop();
  }
}
