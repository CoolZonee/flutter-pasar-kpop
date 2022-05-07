import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/api/image_api.dart';
import 'package:testing_app/api/post_api.dart';
import 'package:testing_app/api/user_api.dart';
import 'package:testing_app/class/post_class.dart' as post_class;
import 'package:testing_app/class/user_class.dart';
import 'package:testing_app/models/auth_model.dart';
import 'package:testing_app/models/post_model.dart';

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
  final ImageAPI imageAPI = ImageAPI();
  bool isLiked = false;
  late final Future? _imageFuture = _getImage();

  @override
  void initState() {
    print("rerender");
    super.initState();
    refreshPost();
  }

  Future<void> likePost() async {
    try {
      await postAPI.likePost(widget.details.id,
          Provider.of<AuthModel>(context, listen: false).getCurrentUser.id);
      Provider.of<PostModel>(context, listen: false).likePost(widget.details.id,
          Provider.of<AuthModel>(context, listen: false).getCurrentUser);
      setState(() {
        isLiked = !isLiked;
      });
    } catch (error) {
      print(error);
    }
  }

  void refreshPost() async {
    getUser(widget.details.creator.id).then((user) {
      if (mounted) {
        setState(() => username = user.username);
      }
    }).catchError((error, stackTrace) {
      log(stackTrace.toString());
      log(error.toString());
    });
  }

  Future<Uint8List> _getImage() async {
    return await imageAPI.getImage(widget.details.imageName);
  }

  @override
  Widget build(BuildContext context) {
    final String id = Provider.of<AuthModel>(context).getCurrentUser.id;
    if (id != "") {
      for (User user in widget.details.likedBy) {
        if (id == user.id) {
          setState(() {
            isLiked = true;
          });
          break;
        }
      }
    } else {
      setState(() {
        isLiked = false;
      });
    }
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
                    FutureBuilder(
                      future: _imageFuture,
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        child: Image.memory(
                                            snapshot.data as Uint8List),
                                      ),
                                    );
                                  });
                            },
                            child: Image.memory(snapshot.data as Uint8List),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                    ),
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
                              onPressed: () async {
                                await likePost();
                              },
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
