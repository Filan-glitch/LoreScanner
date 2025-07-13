// Datenmodell für eine einzelne Filteroption (z.B. eine Checkbox)
import 'package:flutter/material.dart';

class FilterOption {
  final String name;
  bool isSelected;

  FilterOption({required this.name, this.isSelected = false});
}

// Datenmodell für eine Filterkategorie (z.B. "Types", "Cost")
class FilterCategory {
  final String title;
  final List<FilterOption> options;
  // Spezielles Widget für die Farbauswahl
  final Widget? customWidget;

  FilterCategory({
    required this.title,
    this.options = const [],
    this.customWidget,
  });
}