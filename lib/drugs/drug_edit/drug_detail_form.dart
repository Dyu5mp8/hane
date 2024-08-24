import "package:flutter/widgets.dart";
import "package:hane/drugs/models/drug.dart";
import "package:hane/drugs/services/drug_list_provider.dart";
import "package:provider/provider.dart";

class DrugForm {
  List<Concentration> concentrations = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController contraindicationController = TextEditingController();
  List<dynamic> brandNames = [];
  TextEditingController notesController = TextEditingController();
  List<Indication>? indications = [];
  List<dynamic> categories = [];

  Drug? drug;

  DrugForm({Drug? drug}) {
    if (drug != null) {
      this.drug = drug;
      nameController.text = drug.name ?? "";
      contraindicationController.text = drug.contraindication ?? "";
      concentrations = drug.concentrations ?? [];
      notesController.text = drug.notes ?? "";
      indications = drug.indications ?? [];
      brandNames = drug.brandNames ?? [];
      categories = drug.categories ?? [];
    }

  }


 Drug createDrug() {
    return Drug(
      name: nameController.text,
      contraindication: contraindicationController.text,
      concentrations: concentrations,
      notes: notesController.text,
      indications: indications,
      brandNames: brandNames,
      categories: categories
    );
  }

  void saveDrug(context) {
    if (drug == null) {
      drug = createDrug();
    } else {
      drug!.name = nameController.text;
      drug!.contraindication = contraindicationController.text;
      drug!.concentrations = concentrations;
      drug!.notes = notesController.text;
      drug!.indications = indications;
      drug!.brandNames = brandNames;
      drug!.categories = categories;

    }


    drug!.updateDrug();
    var drugListProvider = Provider.of<DrugListProvider>(context, listen: false);
    drugListProvider.addDrug(drug!);

  }
}