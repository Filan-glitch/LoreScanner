import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lorescanner/provider/cards_provider.dart';
import 'package:lorescanner/service/export_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sammlung exportieren'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.import_export),
            title: const Text('Dreamborn.ink'),
            subtitle: const Text('Exportieren als CSV für Dreamborn.ink'),
            onTap: () => _exportDreambornInk(context),
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

  void _exportDreambornInk(BuildContext context) async {
    final navigator = Navigator.of(context);
    final cardsProvider = context.read<CardsProvider>();
    final collection = cardsProvider.collection;

    try {
      final path = join((await getApplicationCacheDirectory()).path,
      'collection.csv');
      final file = File(path);
      final csv = ExportService().toDreambornInk(collection);
      await file.writeAsString(csv, mode: FileMode.writeOnly, flush: true);
      print('Download Directory: ${(await getDownloadsDirectory())?.path ?? 'No Downloads Directory'}');
      final downloadPath = join(
        (Platform.isAndroid) ? '/storage/emulated/0/Download' : (await getDownloadsDirectory())?.path ?? '',
        'collection.csv',
      );
      final downloadFile = await file.copy(downloadPath);
      await downloadFile.create(recursive: true);

      final params = ShareParams(
        text: 'Sammlung exportiert',
        files: [XFile(path, mimeType: 'text/csv')],
      );
      await SharePlus.instance.share(params);

      navigator.pop();
    } catch (e) {
      navigator.pop();
    }
  }
}


