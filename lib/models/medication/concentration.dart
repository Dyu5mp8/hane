class DrugConcentration {
  final double amount;
  final String unit;

  DrugConcentration({required this.amount, required this.unit});

  factory DrugConcentration.fromJson(Map<String, dynamic> json) {
    return DrugConcentration(
      amount: json['amount'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }
}