// Theme System Test File
// This file provides a quick overview of the theme system implementation

import 'package:flutter/material.dart';

class ThemeShowcase extends StatelessWidget {
  const ThemeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Showcase'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Color Palette
          _buildSection(
            context,
            'Color Palette',
            [
              _buildColorRow(context, 'Primary', theme.colorScheme.primary),
              _buildColorRow(context, 'Secondary', theme.colorScheme.secondary),
              _buildColorRow(context, 'Tertiary', theme.colorScheme.tertiary),
              _buildColorRow(context, 'Surface', theme.colorScheme.surface),
              _buildColorRow(context, 'Error', theme.colorScheme.error),
            ],
          ),
          
          // Typography
          _buildSection(
            context,
            'Typography',
            [
              Text('Headline Large', style: theme.textTheme.headlineLarge),
              Text('Headline Medium', style: theme.textTheme.headlineMedium),
              Text('Headline Small', style: theme.textTheme.headlineSmall),
              Text('Body Large', style: theme.textTheme.bodyLarge),
              Text('Body Medium', style: theme.textTheme.bodyMedium),
              Text('Body Small', style: theme.textTheme.bodySmall),
            ],
          ),
          
          // Components
          _buildSection(
            context,
            'Components',
            [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Elevated Button'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: const Text('Text Button'),
              ),
              const SizedBox(height: 8),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Card with ListTile'),
                  subtitle: Text('Subtitle text'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
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
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...children.map((child) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: child,
          )),
        ],
      ),
    );
  }

  Widget _buildColorRow(BuildContext context, String name, Color color) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withAlpha(128),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}