
import 'package:flutter/widgets.dart';

class AppsettingsProvider extends ChangeNotifier {
  String _username = "";
  int _bookCount = 0;
  bool _devMode = false;
  bool _showDevSwitch = false;

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

  bool get devMode => _devMode;

  void setDevMode(bool newDevMode) {
    _devMode = newDevMode;
    notifyListeners();
  }

  bool get showDevSwitch => _showDevSwitch;

  void setShowDevSwitch(bool showDevSwitch){
    _showDevSwitch = showDevSwitch;
    notifyListeners();
  }

}