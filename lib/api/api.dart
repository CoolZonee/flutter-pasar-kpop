import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:testing_app/class/post.dart';

Future<Post> fetchPosts() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  log(response.body);
  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body)[0]);
  }

  throw Exception('Failed to load post');
}
