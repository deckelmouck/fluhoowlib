import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Language'),
                    subtitle: Text(isEnglish ? 'English' : 'German'),
                  ),
                ),
                Switch(
                  value: isEnglish,
                  onChanged: (val) {
                    setState(() {
                      isEnglish = val;
                    });
                  },
                ),
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
              subtitle: Text('0.1.1'),
            ),
            ListTile(
              title: Text('Copyright'),
              subtitle: Text('© 2025 Nikolas Palm'),
            ),
          ],
        ),
      ),
    );
  }
}
