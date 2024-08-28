import 'package:flutter/material.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/drug_detail/drug_detail_view.dart';


class DrugListRow extends StatelessWidget {
  final Drug _drug;

  const DrugListRow(this._drug, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_drug.name == null) {
      return const ListTile(
        title: Text(
          "Felaktig data",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return 
    ListTile(
      dense: true,
      contentPadding: EdgeInsets.only(right: 16.0, top: 0, bottom: 5),
      minLeadingWidth: 0,
      leading: Container(
        width: 5,
        color: _drug.changedByUser ? Theme.of(context).primaryColor : Colors.transparent,),
  
      title: Text(
        _drug.name!,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_drug.brandNames != null)
            Text(
              _drug.brandNames!.join(","),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 11,
                  ),
            ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[600],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DrugDetailView(drug: _drug),
          ),
        );
      },
    );

    }
  }
} 