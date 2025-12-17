
import 'package:flutter/widgets.dart';

class AppsettingsProvider extends ChangeNotifier {
  String _username = "";
  int _bookCount = 0;

  String get username => _username;

  void setUsername(String newUsername)
  {
    _username = newUsername;
    notifyListeners();
  }

  int get bookCount => _bookCount;
  
  void setBookCount(int newBookCount)
  {
    _bookCount = newBookCount;
    notifyListeners();
  }
}