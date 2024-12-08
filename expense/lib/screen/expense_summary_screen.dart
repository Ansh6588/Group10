import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

/// Author: Meet Parmar
/// Description: This screen provides detail of all expenses, calculating how much each participant owes or is owed across all transactions.

class ExpenseSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the list of all expenses from the provider
    final expenses = Provider.of<ExpensesProvider>(context).expenses;

    // Create a map to store the balances between participants
    final Map<String, Map<String, double>> balances = {};

    // Process each expense to calculate balances
    for (var expense in expenses) {
      final perPersonShare = expense.amount / expense.splitBetween.length;

      // Ensure every participant has a balances entry
      if (!balances.containsKey(expense.paidBy)) {
        balances[expense.paidBy] = {};
      }
      for (var person in expense.splitBetween) {
        if (!balances.containsKey(person)) {
          balances[person] = {};
        }
      }

      // Update balances for the payer and participants
      for (var person in expense.splitBetween) {
        if (person != expense.paidBy) {
          balances[expense.paidBy]![person] =
              (balances[expense.paidBy]![person] ?? 0) + perPersonShare;
          balances[person]![expense.paidBy] =
              (balances[person]![expense.paidBy] ?? 0) - perPersonShare;
        }
      }
    }

    // Generate balance messages for display
    List<Widget> balanceMessages = [];

    // Iterate over the balances map to create messages
    balances.forEach((name, balancesMap) {
      String personMessage = "$name:";
      List<Widget> balanceDetails = [];

      balancesMap.forEach((otherName, balance) {
        String message = '';
        Color messageColor = Colors.black;

        if (balance > 0) {
          // This person is owed money
          message = "$otherName owes you CA\$${balance.toStringAsFixed(2)}";
          messageColor = Colors.green;
        } else if (balance < 0) {
          // This person owes money
          message = "You owe $otherName CA\$${(-balance).toStringAsFixed(2)}";
          messageColor = Colors.orange;
        }

        if (message.isNotEmpty) {
          balanceDetails.add(
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
              child: Text(
                message,
                style: TextStyle(fontSize: 18, color: messageColor),
              ),
            ),
          );
        }
      });

      // Add the person header and their balance details to the list
      balanceMessages.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Text(
            personMessage,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );

      balanceMessages.addAll(balanceDetails);
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Expense Summary")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "-------------------------------------------",
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            "|           Expense Summary              |",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Text(
            "-------------------------------------------",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),

          // Display the list of balance messages
          Expanded(
            child: ListView(
              children: balanceMessages,
            ),
          ),
        ],
      ),
    );
  }
}
