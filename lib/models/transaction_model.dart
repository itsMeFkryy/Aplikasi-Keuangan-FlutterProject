class Transaction {
  final String id;
  final DateTime date;
  final String category;
  final double amount;
  final String description;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.date,
    required this.category,
    required this.amount,
    required this.description,
    required this.type,
  });
}

enum TransactionType { income, expense }