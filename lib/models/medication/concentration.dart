class Concentration {
  final double amount;
  final String unit;

Concentration({required this.amount, required this.unit});

 factory Concentration.fromMap(Map<String, dynamic> map) {
    num amount = map['amount'] as num;
    return Concentration(
      amount: amount.toDouble(),
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
