import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/class/user_class.dart';
import 'package:testing_app/models/auth_model.dart';
import 'package:testing_app/models/post_model.dart';
import 'package:testing_app/pages/home_page/home_page.dart';
import 'package:testing_app/pages/login/login_page.dart';
import 'package:testing_app/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();
  String? isLoggedIn = await storage.read(key: 'isLoggedIn');

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostModel(),
        ),
      ],
      child: MyApp(
        isLoggedIn: isLoggedIn == "true" ? true : false,
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  final bool isLoggedIn;
  final storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    storage.read(key: 'user').then((value) {
      if (value != null) {
        Provider.of<AuthModel>(context, listen: false)
            .login(User.fromJson(jsonDecode(value)));
      }
    });
    // Provider.of<AuthModel>(context, listen: false).setLoginStatus(isLoggedIn);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pasar KPOP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isLoggedIn ? const HomePage() : const LoginPage(),
        onGenerateRoute: RouteGenerator.generateRoute);
  }
}
