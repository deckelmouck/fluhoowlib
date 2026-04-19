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
  String get read => 'Read';

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

  @override
  String get publicationDate => 'date of publication';

  @override
  String get publicationDateShort => 'publication';

  @override
  String get finishedDate => 'finished date';

  @override
  String get selectDate => 'selection date';

  @override
  String get noDateSelected => 'no date selected';

  @override
  String get year => 'year';

  @override
  String get date => 'date';

  @override
  String get finished => 'finished';

  @override
  String get publ => 'publ.';

  @override
  String get choose => 'choose';

  @override
  String get enterTitle => 'enter a title';

  @override
  String get enterAuthor => 'enter an author';

  @override
  String get markAsReaded => 'mark as readed';

  @override
  String get licenses => 'Licenses';

  @override
  String get viewLicenses => 'show licenses';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get viewPrivacyPolicy => 'see privacy policy';

  @override
  String get developer => 'Developer';

  @override
  String get theme => 'Color scheme';

  @override
  String get lightdark => 'light - dark';

  @override
  String get isbn13Label => 'isbn 13';

  @override
  String get invalidIsbn => 'this is no valid isbn10 or isbn13';

  @override
  String get devTool => 'dev tool';

  @override
  String get loadingDatabaseInfo => 'Loading database info...';

  @override
  String databaseName(Object name) {
    return 'Database Name: $name';
  }

  @override
  String databaseSize(Object size) {
    return 'Database Size: $size';
  }

  @override
  String get mockupDb => 'Mockup DB';

  @override
  String get deleteAllMockBooks => 'Delete All Mock Books';

  @override
  String get hideRawData => 'Hide Raw Data';

  @override
  String get showRawData => 'Show Raw Data';

  @override
  String get invalidIsbnNo => 'invalid isbn no';

  @override
  String get developerMode => 'Developer mode';

  @override
  String get enableDevPage => 'Enable dev page';

  @override
  String get borrowed => 'Borrowed';

  @override
  String get borrowedBy => 'Borrowed by';

  @override
  String get borrowedSince => 'Since:';

  @override
  String get borrowedTo => 'Borrowed by';
}
