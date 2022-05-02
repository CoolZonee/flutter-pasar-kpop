import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testing_app/api/auth_api.dart';
import 'package:testing_app/components/post/confirmation_dialog_box.dart';
import 'package:testing_app/components/post/loading_spinner.dart';
import 'package:testing_app/pages/login/login_page.dart';
import 'package:testing_app/pages/search_page.dart';
import '../components/post/post.dart' as post_widget;
import '../api/post_api.dart';
import '../class/post_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  final String route = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  final PostAPI postAPI = PostAPI();
  final AuthAPI authAPI = AuthAPI();
  late Future<List<Post>> _futurePost;
  late List<Post> post;
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    // storage.deleteAll();
    setState(() {
      _futurePost = _homePageGetPosts();
    });
    storage.read(key: 'isLoggedIn').then((value) => setState(() {
          isLoggedIn = value == 'true' ? true : false;
        }));
  }

  Future<void> refreshPost() async {
    setState(() {
      _futurePost = _homePageGetPosts();
    });
  }

  Future<List<Post>> _homePageGetPosts() async {
    try {
      return await postAPI.getPosts();
    } catch (error) {
      return Future.error(error);
    }
  }

  void _handleLogOut() {
    showConfirmationDialogBox(context,
        cancelText: "Cancel",
        continueText: "Log Out",
        alertBoxTitle: "Log Out",
        alertBoxContent: "Would you like to log out?", cancelFunc: () {
      Navigator.of(context).pop();
    }, continueFunc: () async {
      onLoading(context, "Logging out...");
      try {
        await authAPI.logout();
        await refreshPost();
        setState(() {
          isLoggedIn = false;
        });
        Navigator.pop(context);
      } catch (error) {
        Navigator.pop(context);
        log(error.toString());
      }
      Navigator.pop(context);
    });
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _futurePost = _homePageGetPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var searchBarWidth = deviceSize.width * 0.60;

    if (deviceSize.width > 768) {
      searchBarWidth = 400;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove back button
        backgroundColor: Colors.pink,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                ModalRoute.of(context)?.settings.name == const HomePage().route
                    ? ""
                    : Navigator.of(context).pushNamed(const HomePage().route);
              },
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset('assets/logo/logo.png')),
            ),
            Center(
              child: Container(
                width: searchBarWidth,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: TextField(
                        readOnly: true,
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(const SearchPage().route);
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search...',
                            border: InputBorder.none))),
              ),
            ),
            isLoggedIn
                ? IconButton(
                    onPressed: _handleLogOut, icon: const Icon(Icons.logout))
                : TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, const LoginPage().route);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ))
          ],
        ),
      ),
      body: _buildPost(),
    );
  }

  // widget
  Widget _buildPost() {
    return FutureBuilder<List<Post>>(
      future: _futurePost,
      builder: (context, snapshot) {
        return RefreshIndicator(
            onRefresh: _pullRefresh, child: _postView(snapshot));
      },
    );
  }

  Widget _postView(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return ListView(shrinkWrap: true, primary: false, children: [
        for (var i in snapshot.data)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: post_widget.Post(
              details: i,
            ),
          )
      ]);
    } else if (snapshot.hasError) {
      return ListView(
          shrinkWrap: true,
          primary: false,
          children: [Text(snapshot.error.toString())]);
    }
    return const Center(child: CircularProgressIndicator());
  }
}
