import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/pages/home_page/home_page.dart';
import 'package:testing_app/pages/login/login_page.dart';
import 'package:testing_app/pages/home_page/search_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return CupertinoPageRoute(builder: (_) => const HomePage());
      case '/search':
        return PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const SearchPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero);
      case '/login':
        return CupertinoPageRoute(builder: (_) => const LoginPage());
      default:
        return _errorRoute(
            "Error function not found " + (settings.name as String));
    }
  }

  static Route<dynamic> _errorRoute(String inMesg) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(inMesg),
        ),
      );
    });
  }
}
