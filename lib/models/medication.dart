class Medication {
  String? name;
  int? dosage;
  String? notes;

  Medication();
  Map<String, dynamic> toJson() => {
    "name": name,
    "dosage": dosage,
    "notes": notes,
  };

  Medication.fromSnapshot(snapshot):
    name = snapshot['brand_name'],
    dosage = snapshot['fixed_dose_mg'],
    notes = snapshot['generic']
    ;     

}