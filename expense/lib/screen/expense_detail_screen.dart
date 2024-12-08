import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

/// Author: Meet Parmar
/// Description: This screen displays detailed information about a expenses like amount, who paid for expense date ad between expense is split, and amount owed by inviduals.
class ExpenseDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseId = ModalRoute.of(context)?.settings.arguments as String?;

    if (expenseId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Expense Details")),
        body: const Center(child: Text("Invalid expense ID.")),
      );
    }

    // Access the selected expense from the provider
    final expense = Provider.of<ExpensesProvider>(context, listen: false)
        .expenses
        .firstWhere((exp) => exp.id == expenseId);

    // Calculate how much each person owes based on the split
    final splitAmount = expense.amount / expense.splitBetween.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the expense description
            Text(
              "Description: ${expense.description}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Display the total expense amount
            Text(
              "Amount: \$${expense.amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            // Display who paid for the expense
            Text(
              "Paid By: ${expense.paidBy}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            // Display the date of the expense
            Text(
              "Date: ${expense.date.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            // Display the list of people splitting the expense
            Text(
              "Split Between: ${expense.splitBetween.join(', ')}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Header for the owed amounts section
            const Text(
              "Amount Owed:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Display the amount owed by each participant
            ...expense.splitBetween.map((person) {
              return Text(
                "- $person: \$${splitAmount.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
