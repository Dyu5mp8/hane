import 'package:flutter/material.dart';
import 'package:hane/drugs/drug_detail/overview/basic_info_row.dart';
import 'package:hane/drugs/drug_detail/overview/contraindication_row.dart';
import 'package:hane/drugs/drug_detail/overview/note_row.dart';
import 'package:hane/drugs/drug_detail/overview/user_note_row.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:hane/ui_components/scroll_indicator.dart';
import 'package:hane/login/user_status.dart';

class OverviewBox extends StatefulWidget {
  const OverviewBox({super.key});

  @override
  State<OverviewBox> createState() => _OverviewBoxState();
}

class _OverviewBoxState extends State<OverviewBox> {
  final ScrollController _scrollController = ScrollController();
  late DrugListProvider provider;
  late Drug drug;

  @override
  void dispose() {
    // Dispose of the scroll controller
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<DrugListProvider>(context, listen: false);
    drug = Provider.of<Drug>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    bool shouldShowUserNotes =
        (provider.userMode == UserMode.syncedMode ||
            provider.userMode == UserMode.reviewer);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 0.5,
          ),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 350),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const BasicInfoRow(),
                  const NoteRow(),
                  const Divider(indent: 10, endIndent: 10, thickness: 1),
                  const ContraindicationRow(),
                  if (shouldShowUserNotes)
                    const Divider(indent: 10, endIndent: 10, thickness: 1),
                  if (shouldShowUserNotes) const UserNoteRow(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Include the ScrollIndicator widget
            Positioned(
              bottom: 15,
              right: 15,
              child: ScrollIndicator(scrollController: _scrollController),
            ),
          ],
        ),
      ),
    );
  }
}
