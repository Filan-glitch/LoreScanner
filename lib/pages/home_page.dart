import 'package:flutter/material.dart';
import 'package:lorescanner/screens/collection_screen.dart';
import 'package:lorescanner/screens/scanner_screen.dart';
import 'package:lorescanner/screens/settings_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: const ScannerScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: 'Scanner',
          ),
        ),
        PersistentTabConfig(
          screen: const CollectionScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.message),
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
      ),
    );
  }
}
