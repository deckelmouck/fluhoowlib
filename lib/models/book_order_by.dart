import '../l10n/app_localizations.dart';

enum BookOrderBy { id, title, author }

extension BookOrderByExtension on BookOrderBy {
  String translatedName(AppLocalizations loc) {
    switch (this) {
      case BookOrderBy.id:
        return 'ID'; // No translation found, fallback to static
      case BookOrderBy.title:
        return loc.bookTitle;
      case BookOrderBy.author:
        return loc.author;
    }
  }

  String get value => toString().split('.').last;

  static BookOrderBy fromValue(String value) {
    return BookOrderBy.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BookOrderBy.id,
    );
  }
}
