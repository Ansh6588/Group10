//Author: Ansh Patel
class Expense {
  final String id;
  final String description;
  final double amount;
  final String paidBy;
  final DateTime date;
  final List<String> splitBetween;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.date,
    required this.splitBetween,
  });
}
