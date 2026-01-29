import 'package:flutter/material.dart';
import 'package:hoowlib/providers/appsettings_provider.dart';
import 'package:hoowlib/pages/dev_page.dart';
import 'models/book.dart';
import 'pages/library_page.dart';
import 'pages/calendar_page.dart';
import 'pages/setting_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'db/database_helper.dart';
import 'package:provider/provider.dart';
import 'providers/books_provider.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    // Set initial locale to system default
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    if (["en", "de"].contains(systemLocale.languageCode)) {
      _locale = Locale(systemLocale.languageCode);
    } else {
      _locale = const Locale('en');
    }
  }

  void _changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppsettingsProvider()),
        ChangeNotifierProvider(create: (context) => BooksProvider()),
      ],
      child: Builder(
        builder: (context) {
          final isDarkMode = context.watch<AppsettingsProvider>().isDarkMode;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: _locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('de', ''),
            ],
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: MainNavigation(onLocaleChanged: _changeLocale),
          );
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final void Function(Locale)? onLocaleChanged;
  const MainNavigation({super.key, this.onLocaleChanged});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  List<Book> _books = [];
  bool _devMode = false;

  final GlobalKey<LibraryPageState> _libraryPageKey = GlobalKey<LibraryPageState>();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _changeDevMode(bool newDevMode) {
    setState(() {
      _devMode = newDevMode;
    });
  }

  Future<void> _loadBooks() async {
    final books = await DatabaseHelper().getBooks();
    setState(() {
      _books = books;
    });
  }

  List<Widget> get _pages => [
        LibraryPage(key: _libraryPageKey, books: _books),
        const CalendarPage(),
        SettingPage(onLocaleChanged: widget.onLocaleChanged, onDevModeChanged: _changeDevMode, devModeParameter: _devMode,),
        DevPage(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    List<BottomNavigationBarItem> bottom = [
      BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 24),
              label: AppLocalizations.of(context)!.myLibrary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month, size: 24),
              label: AppLocalizations.of(context)!.calendar,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 24),
              label: AppLocalizations.of(context)!.settings,
            ),
    ];

    if(Provider.of<AppsettingsProvider>(context).devMode){
      bottom.add(BottomNavigationBarItem(
              icon: Icon(Icons.developer_mode, size: 24,),
              label: "dev",
            ));
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        constraints: BoxConstraints(minHeight: 70, maxHeight: 90),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: bottom,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
