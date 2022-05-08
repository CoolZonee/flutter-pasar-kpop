import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
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

  Future<Post> createPost(Map<String, dynamic> newPost, File imageFile) async {
    try {
      // open a bytestream
      final stream = http.ByteStream(DelegatingStream(imageFile.openRead()));

      // get file length
      final length = await imageFile.length();

      // string to uri
      final uri = Uri.parse('${globals.apiURLPrefix}/posts');

      // create multipart request
      final request = http.MultipartRequest("POST", uri);

      var header = await authAPI.getHeader();
      request.headers.addAll(header);

      // multipart that takes file
      final multiPartFile = http.MultipartFile('image', stream, length,
          filename: basename(imageFile.path));

      // add file to multipart
      request.files.add(multiPartFile);

      // add request body
      newPost.forEach((key, value) {
        if (key == "group" || key == "category") {
          for (String data in value) {
            request.fields[key] = data;
          }
        } else {
          request.fields[key] = value;
        }
      });

      final response = await request.send();

      if (response.statusCode == 201) {
        final post = await response.stream.bytesToString();
        return Post.fromJson(jsonDecode(post)[0]);
      }
      if (response.statusCode == 403) {
        throw Exception("Forbidden");
      }
      throw Exception("Could not create a new post.");
    } catch (error) {
      return Future.error(error);
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
