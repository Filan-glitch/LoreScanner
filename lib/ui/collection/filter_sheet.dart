import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/collection_filter.dart';
import '../../providers.dart';

/// Bottom sheet with working filters: owned-only, set, ink, rarity.
class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key, required this.sets, required this.rarities});

  final List<String> sets;
  final List<String> rarities;

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late CollectionFilter _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(collectionFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Filter', style: theme.textTheme.titleLarge),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      setState(() => _draft = const CollectionFilter()),
                  child: const Text('Zurücksetzen'),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Nur meine Karten'),
              value: _draft.ownedOnly,
              onChanged: (v) =>
                  setState(() => _draft = _draft.copyWith(ownedOnly: v)),
            ),
            _chipSection(
              'Set',
              widget.sets,
              _draft.sets,
              (v) => setState(() => _draft = _draft.copyWith(sets: v)),
            ),
            _chipSection(
              'Tinte',
              knownInks,
              _draft.inks,
              (v) => setState(() => _draft = _draft.copyWith(inks: v)),
            ),
            _chipSection(
              'Seltenheit',
              widget.rarities,
              _draft.rarities,
              (v) => setState(() => _draft = _draft.copyWith(rarities: v)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  ref.read(collectionFilterProvider.notifier).set(_draft);
                  Navigator.pop(context);
                },
                child: const Text('Anwenden'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipSection(
    String title,
    List<String> options,
    Set<String> selected,
    void Function(Set<String>) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleSmall),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final option in options)
              FilterChip(
                label: Text(option),
                selected: selected.contains(option),
                onSelected: (on) {
                  final next = Set<String>.from(selected);
                  on ? next.add(option) : next.remove(option);
                  onChanged(next);
                },
              ),
          ],
        ),
      ],
    );
  }
}
