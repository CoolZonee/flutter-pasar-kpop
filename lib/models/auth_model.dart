import 'package:flutter/material.dart';

import '../class/user_class.dart';

class AuthModel extends ChangeNotifier {
  late bool _isLoggedIn = false;
  late User _currentUser = User("", "", "", "", "");

  bool get authStatus => _isLoggedIn;
  User get getCurrentUser => _currentUser;

  void login(User user) {
    _isLoggedIn = true;
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = User("", "", "", "", "");
    notifyListeners();
  }

  void setLoginStatus(bool status) {
    _isLoggedIn = status;
    notifyListeners();
  }
}
