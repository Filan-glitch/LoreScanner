import 'package:flutter/material.dart';

import '../models/filter.dart';
import '../widgets/color_filter_widget.dart';

class CollectionFilterDialog extends StatefulWidget {
  const CollectionFilterDialog({super.key});

  @override
  State<CollectionFilterDialog> createState() => _CollectionFilterDialogState();
}

class _CollectionFilterDialogState extends State<CollectionFilterDialog> {
  // Zustand für die oberste Checkbox
  bool _showOnlyMyCards = false;

  // Beispieldaten für die Filterkategorien und ihre Optionen
  // In einer echten App würden diese Daten von einer API oder Datenbank kommen
  late final List<FilterCategory> _filterCategories;

  @override
  void initState() {
    super.initState();
    _filterCategories = [
      FilterCategory(
        title: 'Farben',
        // Ein benutzerdefiniertes Widget für die Farbauswahl, wie im Screenshot
        customWidget: const ColorFilterWidget(),
      ),
      FilterCategory(
        title: 'Typen',
        options: [],
      ),
      FilterCategory(
        title: 'Kosten',
        options: [],
      ),
      FilterCategory(
        title: 'Franchise',
        options: []
      ),
    ];
  }

  // Setzt alle Filter zurück
  void _resetFilters() {
    setState(() {
      _showOnlyMyCards = false;
      // Iteriert durch alle Kategorien und Optionen und setzt sie zurück
      for (var category in _filterCategories) {
        for (var option in category.options) {
          option.isSelected = false;
        }
      }
      // Hinweis: Der Zustand des ColorFilterWidget müsste hier auch zurückgesetzt werden.
      // Für die Demo bleibt es einfach.
    });
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: [
          // Die oberste Checkbox
          _buildTopCheckbox(),
          const SizedBox(height: 8),
          // Erstellt die Liste der aufklappbaren Filtersektionen
          ..._filterCategories.map((category) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                title: Text(category.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                childrenPadding: const EdgeInsets.all(16).copyWith(top: 0),
                // Baut entweder das benutzerdefinierte Widget oder die Liste von Checkboxen
                children: [
                  if (category.customWidget != null)
                    category.customWidget!
                  else
                    ...category.options.map((option) {
                      return CheckboxListTile(
                        title: Text(option.name),
                        value: option.isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            option.isSelected = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                ],
              ),
            );
          }).toList(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Filter zurücksetzen und Dialog schließen
          },
          child: const Text('Zurücksetzen'),
        ),
        ElevatedButton(
          onPressed: () {
            // Filter anwenden und Dialog schließen
          },
          child: const Text('Anwenden'),
        ),
      ],
    );
  }

  // Baut die Checkbox "Only show cards in my collection"
  Widget _buildTopCheckbox() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: CheckboxListTile(
        title: const Text('Zeige nur Karten aus meiner Sammlung'),
        value: _showOnlyMyCards,
        onChanged: (bool? value) {
          setState(() {
            _showOnlyMyCards = value ?? false;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      ),
    );
  }

  // Baut die untere Leiste mit "Reset" und "Done" Buttons
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(76),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextButton(
                onPressed: _resetFilters,
                child: const Text('Reset'),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // Filter anwenden und Dialog schließen
                },
                child: const Text('Anwenden'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}