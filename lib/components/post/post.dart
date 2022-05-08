import 'dart:developer';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:testing_app/api/image_api.dart';
import 'package:testing_app/api/post_api.dart';
import 'package:testing_app/class/post_class.dart' as post_class;
import 'package:testing_app/class/user_class.dart';
import 'package:testing_app/models/auth_model.dart';
import 'package:testing_app/models/post_model.dart';
import 'package:testing_app/globals.dart' as globals;

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
  late final Future? _imgFuture = _getImage();
  late final Future? _avatarFuture = _getAvatar();
  String _postTimeAgo = "";

  @override
  void initState() {
    super.initState();
    username = widget.details.creator.username;
    DateTime _now = DateTime.now();
    DateTime _postTime = DateTime.parse(widget.details.createdAt.toString());
    int difference = _now.difference(_postTime).inSeconds;
    if (difference >= 60 && difference < 3600) {
      int time = (difference ~/ 60);
      String ago = time == 1 ? " minute ago" : " minutes ago";
      _postTimeAgo = time.toString() + ago;
    } else if (difference >= 3600 && difference < 86400) {
      int time = (difference ~/ 3600);
      String ago = time == 1 ? " hour ago" : " hours ago";
      _postTimeAgo = time.toString() + ago;
    } else if (difference >= 86400 && difference < 2628288) {
      int time = (difference ~/ 86400);
      String ago = time == 1 ? " day ago" : " days ago";
      _postTimeAgo = time.toString() + ago;
    } else if (difference >= 2628288 && difference < 31536000) {
      int time = (difference ~/ 2628288);
      String ago = time == 1 ? " month ago" : " months ago";
      _postTimeAgo = time.toString() + ago;
    } else if (difference >= 31536000) {
      int time = (difference ~/ 31536000);
      String ago = time == 1 ? " year ago" : " years ago";
      _postTimeAgo = time.toString() + ago;
    } else {
      String ago = difference == 1 ? " second ago" : " seconds ago";
      _postTimeAgo = difference.toString() + ago;
    }
  }

  Future<void> likePost() async {
    try {
      await postAPI.likePost(widget.details.id.toString(),
          Provider.of<AuthModel>(context, listen: false).getCurrentUser.id);
      Provider.of<PostModel>(context, listen: false).likePost(
          widget.details.id.toString(),
          Provider.of<AuthModel>(context, listen: false).getCurrentUser);
      setState(() {
        isLiked = !isLiked;
      });
    } catch (error) {
      log(error.toString());
    }
  }

  Future<Uint8List> _getImage() async {
    return await imageAPI.getImage(widget.details.imageName);
  }

  Future<Uint8List> _getAvatar() async {
    return await imageAPI.getImage(widget.details.creator.avatarName);
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 10, 10),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  imageUrl:
                                      '${globals.apiURLPrefix}/images/${widget.details.creator.avatarName}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover)),
                                  ),
                                ))),
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
                                _postTimeAgo.toString(),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    CachedNetworkImage(
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      imageUrl:
                          '${globals.apiURLPrefix}/images/${widget.details.imageName}',
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
