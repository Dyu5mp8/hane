class Dose {
  final double amount;
  final String unit;

  Dose({required this.amount, required this.unit});

// Factory constructor to create a Dose from a Map
  factory Dose.fromFirestore(Map<String, dynamic> map) {
    return Dose(
      amount: map['amount'] as double,
      unit: map['unit'] as String,
    );
  }

  // Convert a Dose instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }

}
