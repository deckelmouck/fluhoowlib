import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hoowlib App'**
  String get appTitle;

  /// No description provided for @addBook.
  ///
  /// In en, this message translates to:
  /// **'Add Book'**
  String get addBook;

  /// No description provided for @myLibrary.
  ///
  /// In en, this message translates to:
  /// **'My Library'**
  String get myLibrary;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @bookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Title'**
  String get bookTitle;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @noFutureDays.
  ///
  /// In en, this message translates to:
  /// **'You cannot mark future days.'**
  String get noFutureDays;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak: {streak}'**
  String currentStreak(Object streak);

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest streak: {streak}'**
  String longestStreak(Object streak);

  /// No description provided for @todayRead.
  ///
  /// In en, this message translates to:
  /// **'Read today'**
  String get todayRead;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get no;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get close;

  /// No description provided for @deleteBook.
  ///
  /// In en, this message translates to:
  /// **'delete book'**
  String get deleteBook;

  /// No description provided for @booksInLibrary.
  ///
  /// In en, this message translates to:
  /// **'Books in Library'**
  String get booksInLibrary;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @mustNotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'must not be empty'**
  String get mustNotBeEmpty;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @readingHabbit.
  ///
  /// In en, this message translates to:
  /// **'my reading habbit'**
  String get readingHabbit;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'english'**
  String get english;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'german'**
  String get german;

  /// No description provided for @addNewBook.
  ///
  /// In en, this message translates to:
  /// **'add new book'**
  String get addNewBook;

  /// No description provided for @noBooks.
  ///
  /// In en, this message translates to:
  /// **'empty library'**
  String get noBooks;

  /// No description provided for @confirmDeleteBook.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this book?'**
  String get confirmDeleteBook;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// No description provided for @editBook.
  ///
  /// In en, this message translates to:
  /// **'edit book'**
  String get editBook;

  /// No description provided for @editDetailsFor.
  ///
  /// In en, this message translates to:
  /// **'Edit details for'**
  String get editDetailsFor;

  /// No description provided for @warningTitleAuthorNotEmpty.
  ///
  /// In en, this message translates to:
  /// **'Title & Author must not be empty'**
  String get warningTitleAuthorNotEmpty;

  /// No description provided for @publicationDate.
  ///
  /// In en, this message translates to:
  /// **'date of publication'**
  String get publicationDate;

  /// No description provided for @publicationDateShort.
  ///
  /// In en, this message translates to:
  /// **'publication'**
  String get publicationDateShort;

  /// No description provided for @finishedDate.
  ///
  /// In en, this message translates to:
  /// **'finished date'**
  String get finishedDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'selection date'**
  String get selectDate;

  /// No description provided for @noDateSelected.
  ///
  /// In en, this message translates to:
  /// **'no date selected'**
  String get noDateSelected;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'date'**
  String get date;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'finished'**
  String get finished;

  /// No description provided for @publ.
  ///
  /// In en, this message translates to:
  /// **'publ.'**
  String get publ;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'choose'**
  String get choose;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'enter a title'**
  String get enterTitle;

  /// No description provided for @enterAuthor.
  ///
  /// In en, this message translates to:
  /// **'enter an author'**
  String get enterAuthor;

  /// No description provided for @markAsReaded.
  ///
  /// In en, this message translates to:
  /// **'mark as readed'**
  String get markAsReaded;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @viewLicenses.
  ///
  /// In en, this message translates to:
  /// **'show licenses'**
  String get viewLicenses;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @viewPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'see privacy policy'**
  String get viewPrivacyPolicy;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Color scheme'**
  String get theme;

  /// No description provided for @lightdark.
  ///
  /// In en, this message translates to:
  /// **'light - dark'**
  String get lightdark;

  /// No description provided for @isbn13Label.
  ///
  /// In en, this message translates to:
  /// **'isbn 13'**
  String get isbn13Label;

  /// No description provided for @invalidIsbn.
  ///
  /// In en, this message translates to:
  /// **'this is no valid isbn10 or isbn13'**
  String get invalidIsbn;

  /// No description provided for @devTool.
  ///
  /// In en, this message translates to:
  /// **'dev tool'**
  String get devTool;

  /// No description provided for @loadingDatabaseInfo.
  ///
  /// In en, this message translates to:
  /// **'Loading database info...'**
  String get loadingDatabaseInfo;

  /// No description provided for @databaseName.
  ///
  /// In en, this message translates to:
  /// **'Database Name: {name}'**
  String databaseName(Object name);

  /// No description provided for @databaseSize.
  ///
  /// In en, this message translates to:
  /// **'Database Size: {size}'**
  String databaseSize(Object size);

  /// No description provided for @mockupDb.
  ///
  /// In en, this message translates to:
  /// **'Mockup DB'**
  String get mockupDb;

  /// No description provided for @deleteAllMockBooks.
  ///
  /// In en, this message translates to:
  /// **'Delete All Mock Books'**
  String get deleteAllMockBooks;

  /// No description provided for @hideRawData.
  ///
  /// In en, this message translates to:
  /// **'Hide Raw Data'**
  String get hideRawData;

  /// No description provided for @showRawData.
  ///
  /// In en, this message translates to:
  /// **'Show Raw Data'**
  String get showRawData;

  /// No description provided for @invalidIsbnNo.
  ///
  /// In en, this message translates to:
  /// **'invalid isbn no'**
  String get invalidIsbnNo;

  /// No description provided for @developerMode.
  ///
  /// In en, this message translates to:
  /// **'Developer mode'**
  String get developerMode;

  /// No description provided for @enableDevPage.
  ///
  /// In en, this message translates to:
  /// **'Enable dev page'**
  String get enableDevPage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
