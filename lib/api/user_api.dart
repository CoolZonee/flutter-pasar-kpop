import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:testing_app/globals.dart' as globals;
import '../class/user_class.dart';

Future<User> getUser(String id) async {
  try {
    final response =
        await http.get(Uri.parse('${globals.apiURLPrefix}/users/$id'));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      return User.fromJson(body);
    }
  } catch (error, stacktrace) {
    log(stacktrace.toString());
    throw Exception(error);
  }
  throw Exception('Failed to load user');
}
