import 'dart:convert';
import 'package:testing_app/class/user_class.dart';
import 'package:testing_app/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthAPI {
  final storage = const FlutterSecureStorage();

  Map<String, String> headers = {};
  Map<String, dynamic> cookies = {};
  String userId = '';

  Future<User> login(String username, String password) async {
    try {
      final response = await http.post(
          Uri.parse('${globals.apiURLPrefix}/auth/login'),
          body: {"username": username, "password": password});

      if (response.statusCode == 200) {
        User user = User.fromJson(jsonDecode(response.body));

        updateCookie(response);
        await storage.write(key: 'cookie', value: jsonEncode(cookies));
        await storage.write(key: 'user', value: user.toJson());

        userId = user.id;
        await storage.write(key: 'isLoggedIn', value: 'true');

        return user;
      } else if (response.statusCode == 404) {
        throw Exception("Wrong Credentials");
      }
    } catch (error) {
      rethrow;
    }

    throw Exception("Failed to load user");
  }

  Future<dynamic> logout() async {
    try {
      var header = await getHeader();
      final response = await http.post(
          Uri.parse('${globals.apiURLPrefix}/auth/logout'),
          headers: header);
      if (response.statusCode == 200) {
        await storage.deleteAll();
        return;
      } else if (response.statusCode == 403) {
        return await refreshToken().then((_) => logout());
      }
    } catch (error) {
      rethrow;
    }
    throw Exception("Failed to log out");
  }

  Future<dynamic> refreshToken() async {
    try {
      var header = await getHeader();
      final response = await http.post(
          Uri.parse('${globals.apiURLPrefix}/auth/refresh-token'),
          headers: header);
      if (response.statusCode == 200) {
        updateCookie(response);
        await storage.write(key: 'cookie', value: jsonEncode(cookies));
        return;
      } else {
        throw Exception("Failed to refresh cookie");
      }
    } catch (error) {
      rethrow;
    }
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      var setCookies = rawCookie.split(',');
      for (var sc in setCookies) {
        var cookies = sc.split(';');

        for (var cookie in cookies) {
          setCookie(cookie);
        }
      }
      headers['cookie'] = generateCookieHeader();
    }
  }

  void setCookie(String rawCookie) {
    if (rawCookie.isNotEmpty) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key.toLowerCase() == 'path' || key.toLowerCase() == 'expires')
          return;

        cookies[key] = value;
      }
    }
  }

  String generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.isNotEmpty) cookie += ";";
      cookie += key + "=" + cookies[key].toString();
    }
    return cookie;
  }

  Future<Map<String, String>> getHeader() async {
    final String? cookie = await storage.read(key: 'cookie');

    if (cookie != null) {
      cookies = Map<String, dynamic>.from(jsonDecode(cookie));
      // print(cookies);
      headers['cookie'] = generateCookieHeader();
    } else {
      cookies = {};
      headers['cookie'] = '';
    }
    headers['Content-Type'] = 'application/json';

    return headers;
  }
}
