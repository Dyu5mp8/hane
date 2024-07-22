class Concentration {
  final double amount;
  final String unit;

Concentration({required this.amount, required this.unit});

 factory Concentration.fromMap(Map<String, dynamic> map) {
    return Concentration(
      amount: map['amount'] as double,
      unit: map['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }
}