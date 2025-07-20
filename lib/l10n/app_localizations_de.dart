// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Howwlib App';

  @override
  String get addBook => 'Buch hinzufügen';

  @override
  String get myLibrary => 'Meine Bibliothek';

  @override
  String get calendar => 'Kalendar';

  @override
  String get bookTitle => 'Buchtitel';

  @override
  String get author => 'Autor';

  @override
  String get read => 'Gelesen';

  @override
  String get rating => 'Bewertung';

  @override
  String get save => 'Speichern';

  @override
  String get month => 'Monat';

  @override
  String get noFutureDays => 'Du kannst keine zukünftigen Tage markieren.';

  @override
  String currentStreak(Object streak) {
    return 'Aktuelle Serie: $streak';
  }

  @override
  String longestStreak(Object streak) {
    return 'Längste Serie: $streak';
  }

  @override
  String get todayRead => 'Heute gelesen';

  @override
  String get yes => 'ja';

  @override
  String get no => 'nein';

  @override
  String get close => 'schließen';

  @override
  String get deleteBook => 'Buch löschen';

  @override
  String get booksInLibrary => 'Bücher in der Bibliothek';

  @override
  String get clear => 'Löschen';

  @override
  String get mustNotBeEmpty => 'dürfen nicht leer sein';

  @override
  String get settings => 'Einstellungen';

  @override
  String get readingHabbit => 'Meine Lesegewohnheit';

  @override
  String get language => 'Sprache';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get addNewBook => 'neues Buch hinzufügen';

  @override
  String get noBooks => 'leere Bibliothek';

  @override
  String get confirmDeleteBook => 'Soll das Buch wirklich gelöscht werden?';

  @override
  String get cancel => 'abbrechen';

  @override
  String get delete => 'löschen';
}
