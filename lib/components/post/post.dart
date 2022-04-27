import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({Key? key, required final this.details}) : super(key: key);

  final Map details;

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
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                            child: CircleAvatar(
                                radius: 20,
                                backgroundImage: Image.asset(
                                        'assets/avatars/${details["avatarName"]}')
                                    .image),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${details["creator"]}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              '${details["uploadDateTime"]}',
                            )
                          ],
                        )
                      ],
                    ),
                    Image.asset('assets/images/${details["imageName"]}'),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${details["title"]}'),
                            Row(
                              children: [
                                for (var i in details["group"])
                                  GroupRoundedWidget(groupName: i),
                              ],
                            ),
                            Text('${details["price"]}')
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
