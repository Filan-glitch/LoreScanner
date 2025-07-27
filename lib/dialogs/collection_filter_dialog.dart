import 'package:flutter/material.dart';

class CollectionFilterDialog extends StatefulWidget {
  const CollectionFilterDialog({super.key});

  @override
  State<CollectionFilterDialog> createState() => _CollectionFilterDialogState();
}

class _CollectionFilterDialogState extends State<CollectionFilterDialog> {
  // Zustand für die oberste Checkbox
  // bool _showOnlyMyCards = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          children: const []
        ),
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
}