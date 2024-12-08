//Description: This is basic home screen which contains navigation bar for expense summary 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'expense_summary_screen.dart';
import 'add_expense_screen.dart';

//Author: Meet Parmar
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define the screens for each tab
  final List<Widget> _screens = [
    HomeContent(), // The original home content
    ExpenseSummaryScreen(), // The summary screen
  ];

  // Handle navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Highlight the selected tab
        onTap: _onItemTapped, // Handle taps
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize),
            label: 'Summary',
          ),
        ],
      ),
    );
  }
}
//Author: Ansh Patel
//`HomeContent` displays the list of expenses or a message if no expenses exist.
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     // Access the list of expenses from the provider
    final expenses = Provider.of<ExpensesProvider>(context).expenses;

    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      body: expenses.isEmpty
      // Display a message when no expenses have been added
          ? const Center(child: Text("No expenses added yet!"))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(
                  expenses[i].description,
                  style: TextStyle(fontSize: 25),
                ),
                // Display the expense amount as the subtitle
                subtitle: Text(
                  "\$${expenses[i].amount.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18),
                ),
                // Display the date of the expense on top right side
                trailing: Text(
                  "Date: ${expenses[i].date.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  //Navigate to expense Detail screen
                  Navigator.of(context).pushNamed(
                    '/expense_detail',
                    arguments: expenses[i].id,
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        // Navigate to AddExpenseScreen when the button is pressed
        onPressed: () {
          Navigator.of(context).pushNamed('/add-expense');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
