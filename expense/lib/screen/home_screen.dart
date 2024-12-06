import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpensesProvider>(context).expenses;

    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      body: expenses.isEmpty
          ? const Center(child: Text("No expenses added yet!"))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(expenses[i].description,
                  style: TextStyle(fontSize: 25),),
                subtitle: Text("\$${expenses[i].amount.toStringAsFixed(2)}",style: TextStyle(fontSize: 18),),
                
                trailing: Text("Date: ${expenses[i].date.toLocal().toString().split(' ')[0]}",style: TextStyle(fontSize: 18),),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-expense');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
