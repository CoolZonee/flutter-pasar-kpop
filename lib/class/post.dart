// class Post {
//   final String id;
//   final String imageName;
//   final String category;
//   final String title;
//   final String creator;
//   final String avatarName;
//   final String uploadDateTime;
//   final String price;
//   final bool isIncludePos;
//   final List<String> group;
//   final String createdAt;

//   const Post({
//     required this.id,
//     required this.imageName,
//     required this.category,
//     required this.title,
//     required this.creator,
//     required this.avatarName,
//     required this.uploadDateTime,
//     required this.price,
//     required this.isIncludePos,
//     required this.group,
//     required this.createdAt,
//   });

//   factory Post.fromJson(Map<String, dynamic> json){
//     return Post(
//       id: json['id'],
//       imageName: ,
//       category:,
//       title: ,
//       creator: ,
//       avatarName: ,
//       uploadDateTime:,
//       price: ,
//       isIncludePos: ,
//       group: ,
//       createdAt: ,
//     )
//   };
// }

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
