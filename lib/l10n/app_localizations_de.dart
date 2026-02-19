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
  String get calendar => 'Kalender';

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
  String get addNewBook => 'Neues Buch hinzufügen';

  @override
  String get noBooks => 'leere Bibliothek';

  @override
  String get confirmDeleteBook => 'Soll das Buch wirklich gelöscht werden?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get editBook => 'Buch editieren';

  @override
  String get editDetailsFor => 'Details anpassen';

  @override
  String get warningTitleAuthorNotEmpty =>
      'Titel & Autor können nicht leer sein';

  @override
  String get publicationDate => 'Veröffentlichungsdatum';

  @override
  String get publicationDateShort => 'Veröffentlichung';

  @override
  String get finishedDate => 'Gelesen Datum';

  @override
  String get selectDate => 'ausgewähltes Datum';

  @override
  String get noDateSelected => 'kein Datum ausgewählt';

  @override
  String get year => 'Jahr';

  @override
  String get date => 'Datum';

  @override
  String get finished => 'Fertig';

  @override
  String get publ => 'Publ.';

  @override
  String get choose => 'auswählen';

  @override
  String get enterTitle => 'Titel eingeben';

  @override
  String get enterAuthor => 'Autor eingeben';

  @override
  String get markAsReaded => 'als gelesen markieren';

  @override
  String get licenses => 'Lizenzen';

  @override
  String get viewLicenses => 'Lizenzen anzeigen';

  @override
  String get privacyPolicy => 'Datenschutzrichlinie';

  @override
  String get viewPrivacyPolicy => 'Datenschutzrichlinie ansehen';

  @override
  String get developer => 'Entwickler';

  @override
  String get theme => 'Farbschema';

  @override
  String get lightdark => 'hell - dunkel';
}
