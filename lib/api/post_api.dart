import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:testing_app/class/post_class.dart';
import 'package:testing_app/globals.dart' as globals;

Future<List<Post>> getPosts() async {
  try {
    final response = await http.get(Uri.parse('${globals.apiURLPrefix}/posts'));
    if (response.statusCode == 200) {
      List<Post> data = [];
      var body = jsonDecode(response.body);

      for (var i in body) {
        data.add(Post.fromJson(i));
      }
      return data;
    }
  } catch (error, stacktrace) {
    log(stacktrace.toString());
    throw Exception(error);
  }
  throw Exception('Failed to load post');
}
