import 'package:flutter/material.dart';
import 'package:lorescanner/service/api.dart';
import 'package:lorescanner/service/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:lorescanner/provider/cards_provider.dart';

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
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
              child: SizedBox(
                height: 75.0,
                child: Image.asset(
                  'assets/images/icon.png',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: Text(
                'Finn Dilan',
                style: TextStyle(fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                color: Color.fromARGB(255, 117, 117, 117),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Sprache'),
              onTap: () async {
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
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                color: Color.fromARGB(255, 117, 117, 117),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.install_mobile),
              title: const Text('Offizielle Disney Lorcana App'),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    OFFICIAL_APP_URL,
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.web),
              title: const Text('Offizielle Disney Lorcana Website'),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    OFFICIAL_WEBSITE_URL,
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Lizenzen'),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
            /*
            ListTile(
              leading: const Icon(Icons.error),
              title: const Text('Nutzungsbedingungen'),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    TERMS_URL,
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Datenschutz'),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    PRIVACY_URL,
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: const Text('Haftungsausschluss'),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    DISCLAIMER_URL,
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Quellcode'),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    SOURCE_URL,
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Impressum'),
              onTap: () {
                launchUrl(
                  Uri.parse(
                    IMPRINT_URL,
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),*/
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                color: Color.fromARGB(255, 117, 117, 117),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout,
                  color: Colors.red.withAlpha(200)),
              title: const Text('Abmelden'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
