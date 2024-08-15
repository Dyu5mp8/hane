import "package:flutter/material.dart";

class GenericChipForm<T> {
  List<T> items;
  TextEditingController itemController = TextEditingController();

  GenericChipForm({required this.items});

  void addItem() {
    if (itemController.text.isEmpty) return;
    items.add(itemController.text as T);
    itemController.clear();
  }

  void removeItem(T item) {
    items.remove(item);
  }
}