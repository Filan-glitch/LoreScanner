import 'package:flutter/material.dart';
import 'package:lorescanner/provider/cards_provider.dart';
import 'package:lorescanner/service/export_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardsProvider = context.read<CardsProvider>();

    return AlertDialog(
      title: const Text('Export Collection'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.import_export),
            title: const Text('Dreamborn.ink'),
            subtitle: const Text('Export as CSV for Dreamborn.ink'),
            onTap: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final collection = cardsProvider.collection;

              try {
                final csv = ExportService().toDreambornInk(collection);
                final xfile = XFile.fromData(
                  csv.codeUnits,
                  name: 'collection.csv',
                  mimeType: 'text/csv',
                );

                await Share.shareXFiles([xfile], subject: 'Lorescanner Collection');

                navigator.pop();
              } catch (e) {
                navigator.pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Error exporting collection: $e'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
