// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hoowlib App';

  @override
  String get addBook => 'Add Book';

  @override
  String get myLibrary => 'My Library';

  @override
  String get calendar => 'Calendar';

  @override
  String get bookTitle => 'Book Title';

  @override
  String get author => 'Author';

  @override
  String get read => 'Readed';

  @override
  String get rating => 'Rating';

  @override
  String get save => 'Save';

  @override
  String get month => 'Month';

  @override
  String get noFutureDays => 'You cannot mark future days.';

  @override
  String currentStreak(Object streak) {
    return 'Current streak: $streak';
  }

  @override
  String longestStreak(Object streak) {
    return 'Longest streak: $streak';
  }

  @override
  String get todayRead => 'Read today';

  @override
  String get yes => 'yes';

  @override
  String get no => 'no';

  @override
  String get close => 'close';

  @override
  String get deleteBook => 'delete book';

  @override
  String get booksInLibrary => 'Books in Library';

  @override
  String get clear => 'Clear';

  @override
  String get mustNotBeEmpty => 'must not be empty';

  @override
  String get settings => 'Settings';

  @override
  String get readingHabbit => 'my reading habbit';

  @override
  String get language => 'Language';

  @override
  String get english => 'english';

  @override
  String get german => 'german';

  @override
  String get addNewBook => 'add new book';

  @override
  String get noBooks => 'empty library';

  @override
  String get confirmDeleteBook => 'Are you sure you want to delete this book?';

  @override
  String get cancel => 'cancel';

  @override
  String get delete => 'delete';

  @override
  String get editBook => 'edit book';

  @override
  String get editDetailsFor => 'Edit details for';

  @override
  String get warningTitleAuthorNotEmpty => 'Title & Author must not be empty';
}
