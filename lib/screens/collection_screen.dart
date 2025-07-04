import 'package:flutter/material.dart';
import 'package:lorescanner/provider/cards_provider.dart';
import 'package:provider/provider.dart';

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
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await cardsProvider.refreshCollection();
            },
          ),
        ],
      ),
      body: _buildBody(context, cardsProvider, collection),
    );
  }

  Widget _buildBody(BuildContext context, CardsProvider cardsProvider, collection) {
    final theme = Theme.of(context);
    
    if (cardsProvider.isLoadingCollection) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
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
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
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
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
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
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.2),
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
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: collection.entries.length,
            itemBuilder: (context, index) {
              final entry = collection.entries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.card.simpleName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildCardCountBadges(context, entry),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      entry.card.setCode,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: entry.card.images['thumbnail'] != null
                        ? Image.network(
                            entry.card.images['thumbnail']!,
                            width: 60,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 60,
                            height: 80,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.image_not_supported,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                  onTap: () {
                    // Navigate to card detail page or perform any action
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => CardDetailPage(card: card)));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

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
            color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildCardCountBadges(BuildContext context, entry) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (entry.amount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'x${entry.amount}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (entry.amountFoil > 0) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Foil x${entry.amountFoil}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onTertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
