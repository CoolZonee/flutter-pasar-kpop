import 'dart:convert';
import 'dart:developer';

import 'package:testing_app/class/user_class.dart';
import 'package:testing_app/globals.dart' as globals;
import 'package:http/http.dart' as http;

Future<User> login(String username, String password) async {
  try {
    final response = await http.post(
        Uri.parse('${globals.apiURLPrefix}/auth/login'),
        body: {"username": username, "password": password});
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception("Wrong Credentials");
    }
  } catch (error, stacktrace) {
    rethrow;
  }

  throw Exception("Failed to load user");
}
