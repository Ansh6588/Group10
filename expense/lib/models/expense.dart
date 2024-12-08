//Author: Ansh Patel
//Description: this class is defined to represent an individual expense with details like id, description,
//amount, who paid for expense, date and list of people between whom the expense is split.
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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'paidBy': paidBy,
      'date': date.toIso8601String(),
      'splitBetween': splitBetween,
    };
  }

  static Expense fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: json['amount'],
      description: json['description'],
      paidBy: json['paidBy'],
      date: DateTime.parse(json['date']),
      splitBetween: List<String>.from(json['splitBetween']),
    );
  }
  
}
