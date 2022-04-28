import 'package:flutter/material.dart';
import 'package:testing_app/pages/home_page.dart';
import 'package:testing_app/route_generator.dart';
import 'package:localstore/localstore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

const cardDetails = [
  {
    "id": "1",
    "imageName": "testing1.jpg",
    "category": ["WTS", "WTB", "WTT"],
    "title": "jinggybear's new items",
    "creator": "jinggybear",
    "avatarName": "jinggybear.jpg",
    "uploadDateTime": "27 minutes ago",
    "price": "RM25",
    "isIncludePos": false,
    "group": ["Nminxx", "BlackPink", "Aespa"],
    "createdAt": '2022-04-19',
  },
  {
    "id": "2",
    "imageName": "image2.png",
    "category": ["WTS", "WTB"],
    "title": "Irene Photocard",
    "creator": "coolzone",
    "avatarName": "jinggybear.jpg",
    "uploadDateTime": "15 minutes ago",
    "price": "RM25",
    "isIncludePos": true,
    "group": ["Red Velvet"],
    "createdAt": '2022-04-19',
  },
  {
    "id": "3",
    "imageName": "image3.jfif",
    "category": ["WTS"],
    "title": "Bahiyyih pc",
    "creator": "shermin",
    "avatarName": "jinggybear.jpg",
    "uploadDateTime": "10 minutes ago",
    "price": "RM25",
    "isIncludePos": true,
    "group": ["KEP1ER"],
    "createdAt": '2022-04-19',
  },
  {
    "id": "4",
    "imageName": "image3.jfif",
    "category": ["WTS"],
    "title": "Bahiyyih pc",
    "creator": "shermin",
    "avatarName": "jinggybear.jpg",
    "uploadDateTime": "10 minutes ago",
    "price": "RM25",
    "isIncludePos": true,
    "group": ["KEP1ER"],
    "createdAt": '2022-04-19',
  },
  {
    "id": "5",
    "imageName": "image3.jfif",
    "category": ["WTS"],
    "title": "Bahiyyih pc",
    "creator": "shermin",
    "avatarName": "jinggybear.jpg",
    "uploadDateTime": "10 minutes ago",
    "price": "RM25",
    "isIncludePos": true,
    "group": ["KEP1ER"],
    "createdAt": '2022-04-19',
  },
];

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _db = Localstore.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        onGenerateRoute: RouteGenerator.generateRoute);
  }
}
