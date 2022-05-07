import 'package:flutter/material.dart';
import 'package:testing_app/class/post_class.dart';
import 'package:testing_app/class/user_class.dart';

class PostModel extends ChangeNotifier {
  late List<Post> _posts = <Post>[];
  late bool _status = true;

  List<Post> get getPosts => _posts;
  bool get isLoading => _status;

  void setPosts(List<Post> newPosts) {
    _posts = newPosts;
    _status = false;
    notifyListeners();
  }

  void clearPosts() {
    _posts = [];
    notifyListeners();
  }

  void likePost(String id, User user) {
    for (Post p in _posts) {
      if (id == p.id) {
        bool found = false;
        for (User u in p.likedBy) {
          if (u.id == user.id) {
            found = true;
            p.likedBy.remove(u);
            break;
          }
        }
        if (!found) {
          p.likedBy.add(user);
        }
        break;
      }
    }
    notifyListeners();
  }
}
