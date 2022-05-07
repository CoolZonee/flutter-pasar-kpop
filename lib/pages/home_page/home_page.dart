import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/api/auth_api.dart';
import 'package:testing_app/models/post_model.dart';
import 'package:testing_app/pages/home_page/add_post.dart';
import 'package:testing_app/pages/home_page/setting_page.dart';
import 'package:testing_app/pages/search_page.dart';
import '../../components/post/post.dart' as post_widget;
import '../../api/post_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  final PostAPI postAPI = PostAPI();
  final AuthAPI authAPI = AuthAPI();
  late List<Widget> _widgetOptions = <Widget>[];
  int _selectedIndex = 0;

  // widget
  Widget _buildPost() {
    // pull to refresh the post
    return RefreshIndicator(onRefresh: _pullRefresh, child: _postView());
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
                child: post_widget.Post(
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

  @override
  void initState() {
    super.initState();
    getPosts();
    _widgetOptions = [_buildPost(), const AddPostPage(), const SettingPage()];
  }

  Future<void> getPosts() async {
    try {
      final posts = await postAPI.getPosts();
      Provider.of<PostModel>(context, listen: false).setPosts(posts);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> _pullRefresh() async {
    getPosts();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    double _searchBarWidth = deviceSize.width * 0.60;

    if (deviceSize.width > 768) {
      _searchBarWidth = 400;
    }

    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 50,
        child: BottomNavigationBar(
          enableFeedback: true,
          elevation: 5,
          items: [
            _getBotNavItem(Icons.home, "Home", 30),
            _getBotNavItem(Icons.add_circle_outline, "Add Post", 40),
            _getBotNavItem(Icons.account_circle_rounded, "Account", 30),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.pink,
          onTap: onItemTapped,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove back button
        backgroundColor: Colors.pink,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset('assets/logo/logo.png')),
            ),
            Center(
              child: Container(
                width: _searchBarWidth,
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
          ],
        ),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
    );
  }

  BottomNavigationBarItem _getBotNavItem(
          IconData icon, String label, double size) =>
      BottomNavigationBarItem(
          icon: Icon(
            icon,
            size: size,
          ),
          label: label);
}
