import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screen/add_expense_screen.dart';
import './screen/home_screen.dart';
import './providers/expense_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpensesProvider()),
      ],
      child: MaterialApp(
        title: 'Expense Manager',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (ctx) => HomeScreen(),
          '/add-expense': (ctx) => AddExpenseScreen(),
        },
      ),
    );
  }
}
