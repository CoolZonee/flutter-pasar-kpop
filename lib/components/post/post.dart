import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testing_app/api/post_api.dart';
import 'package:testing_app/api/user_api.dart';
import 'package:testing_app/class/post_class.dart' as post_class;
import 'package:testing_app/class/user_class.dart';
import 'package:testing_app/pages/login/login_page.dart';

class Post extends StatefulWidget {
  const Post({Key? key, required final this.details}) : super(key: key);

  final post_class.Post details;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final storage = const FlutterSecureStorage();
  late String username = "";
  final PostAPI postAPI = PostAPI();
  bool isLiked = false;
  bool isLoggedIn = false;
  late User currentUser = User("", "", "", "", "");
  @override
  void initState() {
    super.initState();
    refreshPost();
    storage.read(key: 'isLoggedIn').then((value) => setState(() {
          isLoggedIn = value == 'true' ? true : false;
        }));
  }

  @override
  void didUpdateWidget(Post oldWidget) {
    super.didUpdateWidget(oldWidget);
    refreshPost();
  }

  void likePost() async {
    if (!isLoggedIn) {
      Navigator.of(context).pushNamed(const LoginPage().route);
      return;
    }
    await postAPI.likePost(widget.details.id, currentUser.id);
    setState(() {
      isLiked = !isLiked;
    });
  }

  void refreshPost() async {
    getUser(widget.details.creator.id).then((user) {
      setState(() => username = user.username);
    }).catchError((error, stackTrace) {
      log(stackTrace.toString());
      log(error.toString());
    });
    storage.read(key: 'user').then((user) {
      if (user != null) {
        currentUser = User.fromJson(jsonDecode(user));
      } else {
        currentUser = User("", "", "", "", "");
      }
      checkIfLiked();
    });
  }

  void checkIfLiked() {
    if (currentUser.id != "") {
      for (User user in widget.details.likedBy) {
        if (currentUser.id == user.id) {
          setState(() {
            isLiked = true;
          });
          break;
        }
        setState(() {
          isLiked = false;
        });
      }
    } else {
      setState(() {
        isLiked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                            child: CircleAvatar(
                                radius: 20,
                                backgroundImage: Image.asset(
                                        'assets/avatars/${widget.details.avatarName}')
                                    .image),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                widget.details.createdAt,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    child: Image.asset(
                                        'assets/images/${widget.details.imageName}'),
                                  ),
                                );
                              });
                        },
                        child: Image.asset(
                            'assets/images/${widget.details.imageName}')),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.details.title),
                                Row(
                                  children: [
                                    for (var i in widget.details.group)
                                      GroupRoundedWidget(groupName: i),
                                  ],
                                ),
                                Text(widget.details.price)
                              ]),
                          IconButton(
                              splashRadius: 20,
                              onPressed: likePost,
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline_rounded,
                                color: Colors.pink,
                              ))
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}

class GroupRoundedWidget extends StatelessWidget {
  const GroupRoundedWidget({
    Key? key,
    required this.groupName,
  }) : super(key: key);

  final String groupName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 227, 113, 197)),
          color: const Color.fromARGB(255, 227, 113, 197),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Text(
          groupName,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
