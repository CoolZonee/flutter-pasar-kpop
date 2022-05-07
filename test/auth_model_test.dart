import 'package:test/test.dart';
import 'package:testing_app/class/user_class.dart';
import 'package:testing_app/models/auth_model.dart';

void main() {
  test('login change authStatus to true', () async {
    final auth = AuthModel();
    final User user = User(
        "5", "coolzone", "ckeat0203@gmail.com", "coolzone.jpg", "31-5-2022");
    auth.addListener(() {
      expect(auth.authStatus, true);
      expect(auth.getCurrentUser, user);
    });

    auth.login(user);
  });

  test('logout change authStatus to false', () async {
    final auth = AuthModel();
    final User user = User("", "", "", "", "");
    auth.addListener(() {
      expect(auth.authStatus, false);
      expect(auth.getCurrentUser, user);
    });

    auth.logout();
  });
}
