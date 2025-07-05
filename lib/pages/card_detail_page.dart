import 'package:flutter/material.dart' hide Card;
import 'package:lorescanner/models/card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardDetailPage extends StatelessWidget {
  final Card card;
  const CardDetailPage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.simpleName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Karte teilen',
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large card image at the top
            Semantics(
              label: 'Kartenbild für ${card.simpleName}',
              child: _buildCardImage(context),
            ),
            
            // Card name and basic info
            _buildCardHeader(context),
            
            // Card attributes section
            _buildCardAttributes(context),
            
            // Add some bottom padding for better scrolling
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      height: 400,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(51),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: card.images['full'] != null
            ? CachedNetworkImage(
                imageUrl: card.images['full']!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Lade Kartenbild...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Bild nicht verfügbar',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Versuche es später erneut',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Kein Bild verfügbar',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Für diese Karte ist kein Bild hinterlegt',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withAlpha(153),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card name
          Text(
            card.simpleName,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          
          // Set code
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              card.setCode,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCardAttributes(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get all card attributes as a map for generic display
    final attributes = _getCardAttributes();
    
    // Filter attributes based on the helper method
    final filteredAttributes = Map<String, dynamic>.fromEntries(
      attributes.entries.where((entry) => _shouldShowAttribute(entry.key, entry.value))
    );
    
    if (filteredAttributes.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withAlpha(51),
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'Keine weiteren Karteninformationen verfügbar',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha(51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Karteninformationen',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          
          // Attributes list
          ...filteredAttributes.entries.map((entry) => _buildAttributeItem(context, entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildAttributeItem(BuildContext context, String label, dynamic value) {
    final theme = Theme.of(context);
    
    return Semantics(
      label: '$label: ${_formatValue(value)}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withAlpha(26),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Text(
                _formatValue(value),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getCardAttributes() {
    final attributes = <String, dynamic>{};
    
    // Add current card attributes (always available)
    attributes['ID'] = card.id;
    attributes['Sprache'] = _getLanguageLabel(card.language);
    
    // Add image information
    if (card.images.isNotEmpty) {
      final imageTypes = card.images.keys.map((key) => _getImageTypeLabel(key)).join(', ');
      attributes['Verfügbare Bilder'] = imageTypes;
    }
    
    // TODO: When optional fields are uncommented in the Card model,
    // add them here using reflection or manual mapping.
    // This makes the detail page automatically adapt to new fields.
    // Example implementation for future use:
    /*
    if (card.name != null) attributes['Vollständiger Name'] = card.name;
    if (card.type != null) attributes['Typ'] = card.type;
    if (card.cost != null) attributes['Kosten'] = card.cost;
    if (card.strength != null) attributes['Stärke'] = card.strength;
    if (card.willpower != null) attributes['Willenskraft'] = card.willpower;
    if (card.lore != null) attributes['Wissen'] = card.lore;
    if (card.rarity != null) attributes['Seltenheit'] = card.rarity;
    if (card.color != null) attributes['Farbe'] = card.color;
    if (card.colors != null && card.colors!.isNotEmpty) {
      attributes['Farben'] = card.colors!.join(', ');
    }
    if (card.subtypes != null && card.subtypes!.isNotEmpty) {
      attributes['Untertypen'] = card.subtypes!.join(', ');
    }
    if (card.keywordAbilities != null && card.keywordAbilities!.isNotEmpty) {
      attributes['Schlüsselwörter'] = card.keywordAbilities!.join(', ');
    }
    if (card.flavorText != null) attributes['Geschmackstext'] = card.flavorText;
    if (card.fullText != null) attributes['Volltext'] = card.fullText;
    if (card.artists != null && card.artists!.isNotEmpty) {
      attributes['Künstler'] = card.artists!.join(', ');
    }
    if (card.story != null) attributes['Geschichte'] = card.story;
    if (card.variant != null) attributes['Variante'] = card.variant;
    if (card.version != null) attributes['Version'] = card.version;
    if (card.number != null) attributes['Nummer'] = card.number;
    if (card.maxCopiesInDeck != null) attributes['Max. Kopien im Deck'] = card.maxCopiesInDeck;
    if (card.bannedSince != null) attributes['Verboten seit'] = card.bannedSince;
    if (card.moveCost != null) attributes['Bewegungskosten'] = card.moveCost;
    if (card.inkwell != null) attributes['Tintenfass'] = card.inkwell! ? 'Ja' : 'Nein';
    if (card.isExternalReveal != null) attributes['Externe Enthüllung'] = card.isExternalReveal! ? 'Ja' : 'Nein';
    */
    
    return attributes;
  }
  
  String _getLanguageLabel(String language) {
    switch (language.toLowerCase()) {
      case 'de':
        return 'Deutsch';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'it':
        return 'Italiano';
      case 'es':
        return 'Español';
      default:
        return language.toUpperCase();
    }
  }
  
  String _getImageTypeLabel(String imageType) {
    switch (imageType.toLowerCase()) {
      case 'full':
        return 'Vollbild';
      case 'thumbnail':
        return 'Vorschaubild';
      case 'small':
        return 'Klein';
      case 'large':
        return 'Groß';
      default:
        return imageType;
    }
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'N/A';
    if (value is List) {
      if (value.isEmpty) return 'Keine';
      return value.join(', ');
    }
    if (value is Map) {
      if (value.isEmpty) return 'Keine';
      return value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    }
    if (value is bool) {
      return value ? 'Ja' : 'Nein';
    }
    return value.toString();
  }

  /// Helper method to determine if a card attribute should be displayed
  /// This can be used to filter out attributes based on user preferences
  /// or card type in future implementations
  bool _shouldShowAttribute(String key, dynamic value) {
    // Hide null or empty values
    if (value == null) return false;
    if (value is String && value.isEmpty) return false;
    if (value is List && value.isEmpty) return false;
    if (value is Map && value.isEmpty) return false;
    
    // Always show basic attributes
    if (['ID', 'Sprache', 'Verfügbare Bilder'].contains(key)) return true;
    
    // In future, this could be expanded to handle user preferences
    // or card-type-specific attribute filtering
    return true;
  }
}
