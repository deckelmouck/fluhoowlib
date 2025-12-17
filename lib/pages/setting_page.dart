import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../l10n/app_localizations.dart';

class SettingPage extends StatefulWidget {
  final void Function(Locale)? onLocaleChanged;
  final void Function(bool)? onDevModeChanged;
  final bool? devModeParameter;
  const SettingPage({super.key, this.onLocaleChanged, this.onDevModeChanged, this.devModeParameter});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isEnglish = true;
  String? _appVersion;
  bool _initialized = false;
  bool devModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    devModeEnabled = widget.devModeParameter!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final locale = Localizations.localeOf(context);
      setState(() {
        isEnglish = locale.languageCode.toLowerCase().startsWith('en');
        _initialized = true;
      });
    }
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
          child: AppBar(
            title: Text(
              loc.settings,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(loc.language),
                          subtitle: Text(isEnglish ? loc.english : loc.german),
                        ),
                      ),
                      Switch(
                        value: isEnglish,
                        onChanged: (val) {
                          setState(() {
                            isEnglish = val;
                          });
                          if (widget.onLocaleChanged != null) {
                            widget.onLocaleChanged!(Locale(isEnglish ? 'en' : 'de'));
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: ListTile(
                        title: Text('developer mode'),
                        subtitle: Text('enable dev page'),
                      )),
                      Switch(value: devModeEnabled, onChanged: (val) {
                        setState(() {
                          devModeEnabled = !devModeEnabled;
                        });
                        if (widget.onDevModeChanged != null) {
                          widget.onDevModeChanged!(devModeEnabled);
                        }
                      })
                    ],
                  ),
                  Divider(height: 32),
                  Text('About', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 8),
                  ListTile(
                    title: Text('Developer'),
                    subtitle: Text('Nikolas Palm'),
                  ),
                  ListTile(
                    title: Text('Support'),
                    subtitle: GestureDetector(
                      onTap: () async {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'deckelmouck@gmail.com',
                        );
                        await launchUrl(emailLaunchUri);
                      },
                      child: Text(
                        'deckelmouck@gmail.com',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Homepage'),
                    subtitle: GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse('https://www.deckelmouck.de');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Text(
                        'deckelmouck.de',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Privacy'),
                    subtitle: GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse('https://www.deckelmouck.de/Hoowlib/Privacy');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Text(
                        'See privacy policy',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Version'),
                    subtitle: Text(_appVersion ?? 'Loading...'),
                  ),
                  ListTile(
                    title: Text('Copyright'),
                    subtitle: Text('© 2025 Nikolas Palm'),
                  ),
                ],
              ),
            ),
          ],        
        ),
      ),
    );
  }
}
