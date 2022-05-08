import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testing_app/api/auth_api.dart';
import 'package:testing_app/pages/home_page/add_post_page.dart';
import 'package:testing_app/pages/home_page/favourite_page.dart';
import 'package:testing_app/pages/home_page/post_list_page.dart';
import 'package:testing_app/pages/home_page/search_page.dart';
import 'package:testing_app/pages/home_page/setting_page.dart';
import 'package:testing_app/api/post_api.dart';

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

  @override
  void initState() {
    super.initState();

    _widgetOptions = [
      const PostListPage(),
      // avoid other pages built unnecessarily
      const SizedBox(),
      const SizedBox(),
      const SizedBox(),
      const SizedBox(),
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      if (_widgetOptions[index] is SizedBox) {
        if (index == 1) {
          _widgetOptions[index] = const SearchPage();
          return;
        }

        if (index == 2) {
          _widgetOptions[index] = const AddPostPage();
          return;
        }

        if (index == 3) {
          _widgetOptions[index] = const FavouritePage();
          return;
        }

        if (index == 4) {
          _widgetOptions[index] = const SettingPage();
          return;
        }
      }
    });
    _selectedIndex = index; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 50,
        child: BottomNavigationBar(
          enableFeedback: true,
          elevation: 5,
          items: [
            _getBotNavItem(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                "Home",
                _selectedIndex == 0 ? 35 : 30),
            _getBotNavItem(
                Icons.search, "Search", _selectedIndex == 1 ? 35 : 30),
            _getBotNavItem(
                _selectedIndex == 2
                    ? Icons.add_circle
                    : Icons.add_circle_outline,
                "Add Post",
                _selectedIndex == 2 ? 35 : 30),
            _getBotNavItem(
                _selectedIndex == 3
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                "Favourite",
                _selectedIndex == 3 ? 35 : 30),
            _getBotNavItem(
                _selectedIndex == 4
                    ? Icons.account_circle_rounded
                    : Icons.account_circle_outlined,
                "Account",
                _selectedIndex == 4 ? 35 : 30),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.pink,
          selectedItemColor: Colors.pink,
          backgroundColor: Colors.white,
          onTap: onItemTapped,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove back button
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Pasar KPOP",
          style: TextStyle(color: Colors.pink, fontFamily: "WaterBrush"),
        ),
      ),
      // keep page alive when switching (without rebuild)
      body: WillPopScope(
        onWillPop: () async {
          return !await Navigator.maybePop(context);
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
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
