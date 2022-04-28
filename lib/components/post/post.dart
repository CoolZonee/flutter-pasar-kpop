import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testing_app/api/user_api.dart';
import 'package:testing_app/class/post_class.dart' as post_class;

class Post extends StatefulWidget {
  const Post({Key? key, required final this.details}) : super(key: key);

  final post_class.Post details;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late String username = "";
  @override
  void initState() {
    super.initState();
    getUser(widget.details.creator)
        .then((value) => {setState(() => username = value.username)})
        .catchError((error) => print(error));
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
                    Image.asset('assets/images/${widget.details.imageName}'),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
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
