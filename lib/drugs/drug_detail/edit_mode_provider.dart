import "package:flutter/material.dart";

export "package:provider/provider.dart";

class EditModeProvider with ChangeNotifier {
  bool _editMode = false;

  bool get editMode => _editMode;

  void toggleEditMode() {
    _editMode = !_editMode;
    notifyListeners();
  }

  void setEditMode(bool value) {
    _editMode = value;
    notifyListeners();
  }
}