import 'package:flutter/material.dart';
import 'package:lorescanner/provider/tab_notifier.dart';
import 'package:lorescanner/screens/collection_screen.dart';
import 'package:lorescanner/screens/scanner_screen.dart';
import 'package:lorescanner/screens/settings_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TabNotifier _tabNotifier = TabNotifier(0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PersistentTabView(
      backgroundColor: Colors.transparent,
      onTabChanged: (index) {
        _tabNotifier.value = index;
      },
      tabs: [
        PersistentTabConfig(
          screen: ScannerScreen(tabNotifier: _tabNotifier),
          item: ItemConfig(
            icon: const Icon(Icons.camera_alt),
            title: 'Scanner',
            activeColorSecondary: theme.colorScheme.secondary
          ),
        ),
        PersistentTabConfig(
          screen: const CollectionScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.collections_bookmark),
            title: 'Sammlung',
          ),
        ),
        PersistentTabConfig(
          screen: const SettingsScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: 'Einstellungen',
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: theme.colorScheme.primaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        ),
      ),
    );
  }
}
