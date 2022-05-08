import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/api/auth_api.dart';
import 'package:testing_app/api/post_api.dart';
import 'package:testing_app/models/post_model.dart';
// import 'package:testing_app/class/post_class.dart';
import 'package:testing_app/components/post/post.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final PostAPI postAPI = PostAPI();
  final AuthAPI authAPI = AuthAPI();

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Widget _postView() {
    return Consumer<PostModel>(builder: (context, value, child) {
      if (!value.isLoading) {
        return ListView(
          shrinkWrap: false,
          primary: false,
          children: [
            // load a list of posts
            for (var i in value.getPosts)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Post(
                  details: i,
                ),
              ),
          ],
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Future<void> _pullRefresh() async {
    getPosts();
  }

  Future<void> getPosts() async {
    try {
      final posts = await postAPI.getPosts();
      Provider.of<PostModel>(context, listen: false).setPosts(posts);
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(onRefresh: _pullRefresh, child: _postView());
  }
}
