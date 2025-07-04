import 'package:flutter/material.dart';
import 'package:lorescanner/service/api.dart';
import 'package:lorescanner/service/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:lorescanner/provider/cards_provider.dart';
import 'package:lorescanner/provider/theme_provider.dart';

import '../constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'de'; // Default language

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header section with app icon and developer info
            Container(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/icon.png',
                      height: 80,
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Lore Scanner',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Finn Dilan',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // Settings sections
            _buildSettingsSection(
              context,
              'Darstellung',
              [
                _buildThemeListTile(context, themeProvider),
              ],
            ),
            
            _buildSettingsSection(
              context,
              'Sprache',
              [
                _buildLanguageListTile(context),
              ],
            ),
            
            _buildSettingsSection(
              context,
              'Informationen',
              [
                _buildInfoListTile(
                  context,
                  Icons.install_mobile,
                  'Offizielle Disney Lorcana App',
                  () => _launchUrl(OFFICIAL_APP_URL),
                ),
                _buildInfoListTile(
                  context,
                  Icons.web,
                  'Offizielle Disney Lorcana Website',
                  () => _launchUrl(OFFICIAL_WEBSITE_URL),
                ),
                _buildInfoListTile(
                  context,
                  Icons.account_balance,
                  'Lizenzen',
                  () => showLicensePage(context: context),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Logout button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.logout,
                  color: theme.colorScheme.error,
                ),
                label: Text(
                  'Abmelden',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                  foregroundColor: theme.colorScheme.onErrorContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeListTile(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: theme.colorScheme.primary,
      ),
      title: const Text('Design'),
      subtitle: Text(_getThemeModeName(themeProvider.themeMode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemeDialog(context, themeProvider),
    );
  }

  Widget _buildLanguageListTile(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        Icons.language,
        color: theme.colorScheme.primary,
      ),
      title: const Text('Sprache'),
      subtitle: Text(_selectedLanguage == 'de' ? 'Deutsch' : 'English'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageDialog(context),
    );
  }

  Widget _buildInfoListTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(title),
      trailing: const Icon(Icons.open_in_new, size: 20),
      onTap: onTap,
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Hell';
      case ThemeMode.dark:
        return 'Dunkel';
      case ThemeMode.system:
        return 'System';
    }
  }

  Future<void> _showThemeDialog(BuildContext context, ThemeProvider themeProvider) async {
    final theme = Theme.of(context);
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Design auswählen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(
                context,
                'Hell',
                Icons.light_mode,
                ThemeMode.light,
                themeProvider.themeMode,
                (mode) => themeProvider.setThemeMode(mode),
              ),
              _buildThemeOption(
                context,
                'Dunkel',
                Icons.dark_mode,
                ThemeMode.dark,
                themeProvider.themeMode,
                (mode) => themeProvider.setThemeMode(mode),
              ),
              _buildThemeOption(
                context,
                'System',
                Icons.settings_brightness,
                ThemeMode.system,
                themeProvider.themeMode,
                (mode) => themeProvider.setThemeMode(mode),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Schließen'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    IconData icon,
    ThemeMode mode,
    ThemeMode currentMode,
    Function(ThemeMode) onChanged,
  ) {
    final theme = Theme.of(context);
    
    return RadioListTile<ThemeMode>(
      title: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
      value: mode,
      groupValue: currentMode,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
          Navigator.of(context).pop();
        }
      },
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    final String? selectedLanguage = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sprache ändern'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('Deutsch'),
                    value: 'de',
                    groupValue: _selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Englisch'),
                    value: 'en',
                    groupValue: _selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_selectedLanguage);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    
    if (selectedLanguage != null) {
      setState(() {
        _selectedLanguage = selectedLanguage;
      });
      fetchCards(_selectedLanguage).then((cards) {
        insertCards(cards);
        context.read<CardsProvider>().setCards(cards);
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}
