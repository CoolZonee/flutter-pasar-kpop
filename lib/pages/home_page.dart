import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
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
  final _db = Localstore.instance;
  Future<bool> _onWillPop() async {
    return false;
  }

  late Future<List<Post>> _futurePost;
  late List<Post> post;
  late String errorMessage;
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _futurePost = getPosts().then((value) => post = value).catchError((error) {
      errorMessage = error.toString();
    });
    _db.collection('isLoggedIn').doc('status').get().then((value) {
      setState(() {
        isLoggedIn = value?["isLoggedIn"];
      });
    });
  }

  void handleLogOut() {
    _db.collection('isLoggedIn').doc('status').set({"isLoggedIn": false});
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var searchBarWidth = deviceSize.width * 0.60;

    if (deviceSize.width > 768) {
      searchBarWidth = 400;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // remove back button
            backgroundColor: Colors.pink,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    ModalRoute.of(context)?.settings.name ==
                            const HomePage().route
                        ? ""
                        : Navigator.of(context)
                            .pushNamed(const HomePage().route);
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
                        onPressed: handleLogOut, icon: const Icon(Icons.logout))
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
          body: FutureBuilder<List<Post>>(
            future: _futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(children: [
                  for (var i in post)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: post_widget.Post(
                        details: i,
                      ),
                    )
                ]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator());
            },
          )),
    );
  }
}
