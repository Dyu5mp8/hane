class Medication {
  String name;
  int dosage;
  String notes;

  // Default constructor with optional parameters and default values
  Medication({
    String? name,
    int? dosage,
    String? notes,
  }) : this.name = name ?? 'Default Name',
       this.dosage = dosage ?? 0, // Assuming a dosage of 0 is acceptable as default
       this.notes = notes ?? 'No Notes';

  // Map to JSON function for serialization
  Map<String, dynamic> toJson() => {
    "name": name,
    "dosage": dosage,
    "notes": notes,
  };

  // Factory constructor from snapshot
  Medication.fromSnapshot(snapshot)
    : name = snapshot['brand_name'] ?? 'Default Name',
      dosage = snapshot['fixed_dose_mg'] ?? 0,
      notes = snapshot['generic'] ?? 'No Notes';
}