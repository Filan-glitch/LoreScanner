import 'package:flutter/material.dart';
import 'package:lorescanner/models/collection.dart';
import 'package:lorescanner/provider/cards_provider.dart';
import 'package:lorescanner/widgets/collection_item.dart';
import 'package:provider/provider.dart';

import '../dialogs/export_dialog.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardsProvider = context.watch<CardsProvider>();
    final collection = cardsProvider.collection;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sammlung'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const ExportDialog(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: const Icon(Icons.filter_alt),
        tooltip: 'Sammlung filtern',
      ),
      body: _buildBody(context, cardsProvider, collection),
    );
  }

  Widget _buildBody(BuildContext context, CardsProvider cardsProvider, Collection collection) {
    final theme = Theme.of(context);
    
    if (cardsProvider.isLoadingCollection) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Empty collection
    if (collection.entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withAlpha(77),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.collections_bookmark_outlined,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Deine Sammlung ist leer',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Scanne Karten, um sie zu deiner Sammlung hinzuzufügen',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(179),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Display collection statistics and items
    return Column(
      children: [
        // Statistics header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                'Karten',
                '${collection.entries.length}',
                Icons.credit_card,
              ),
              Container(
                height: 40,
                width: 1,
                color: theme.colorScheme.onPrimaryContainer.withAlpha(51),
              ),
              _buildStatItem(
                context,
                'Gesamt',
                '${collection.totalCards}',
                Icons.inventory_2,
              ),
            ],
          ),
        ),
        
        // Collection list
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: collection.entries.length,
            itemBuilder: (context, index) {
              final entry = collection.entries[index].card;
              return CollectionItem(item: entry);
            },
          )
        )
      ],
    );
  }

  /* Widget _buildSearchBar(BuildContext context) {
    return Container();
  }*/

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withAlpha(204),
          ),
        ),
      ],
    );
  }
}
