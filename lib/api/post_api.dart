import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:testing_app/api/auth_api.dart';
import 'package:testing_app/class/post_class.dart';
import 'package:testing_app/globals.dart' as globals;

class PostAPI {
  final AuthAPI authAPI = AuthAPI();
  Future<List<Post>> getPosts() async {
    try {
      var header = await authAPI.getHeader();
      final response = await http
          .get(Uri.parse('${globals.apiURLPrefix}/posts'), headers: header);
      if (response.statusCode == 200) {
        authAPI.updateCookie(response);
        List<Post> data = [];
        var body = jsonDecode(response.body);

        for (var i in body) {
          Post post = Post.fromJson(i);
          data.add(post);
        }
        return data;
      } else if (response.statusCode == 403) {
        return await authAPI.refreshToken().then((_) => getPosts());
      }
      throw ("No Posts Found.");
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      return Future.error(error.toString());
    }
  }

  Future<Post> updatePost() async {
    try {
      var header = await authAPI.getHeader();
      final response = await http.put(Uri.parse('${globals.apiURLPrefix}/'),
          headers: header);

      if (response.statusCode == 200) {
        authAPI.updateCookie(response);
        return Post.fromJson(jsonDecode(response.body));
      }

      throw ("Update Post Failed.");
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      return Future.error(error.toString());
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      var header = await authAPI.getHeader();
      final response = await http.put(
          Uri.parse('${globals.apiURLPrefix}/posts/like-post'),
          headers: header,
          body: jsonEncode({"postId": postId, "userId": userId}));

      if (response.statusCode == 200) {
        authAPI.updateCookie(response);
        return;
      }
      if (response.statusCode == 403) {
        await authAPI.refreshToken();
        await likePost(postId, userId);
      }

      throw ("Like Post Failed.");
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      return Future.error(error.toString());
    }
  }
}
