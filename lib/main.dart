import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/api/api.dart';
import 'package:testing_app/components/post/post.dart' as post_widget;
import 'package:testing_app/class/post.dart';
import 'package:testing_app/pages/search.dart';

void main() {
  runApp(const MyApp());
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const SearchPage())),
                icon: const Icon(Icons.search))
          ],
        ),
        body: FutureBuilder<Post>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(children: [
                for (var i in cardDetails)
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
        ));
  }
}
