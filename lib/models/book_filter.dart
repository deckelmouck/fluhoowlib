import '../l10n/app_localizations.dart';

enum BookFilter { all, borrowed, read, unread }

extension BookFilterExtension on BookFilter {
  String translatedName(AppLocalizations loc) {
    switch (this) {
      case BookFilter.all:
        return loc.all;
      case BookFilter.borrowed:
        return loc.borrowed;
      case BookFilter.read:
        return loc.read;
      case BookFilter.unread:
        return loc.unread;
    }
  }

  String get value => toString().split('.').last;

  static BookFilter fromValue(String value) {
    return BookFilter.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BookFilter.all,
    );
  }
}