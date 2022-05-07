import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:testing_app/class/user_class.dart';

class Post {
  final String id;
  final String imageName;
  final List category;
  final String title;
  final User creator;
  final String avatarName;
  final String price;
  final bool isIncludePos;
  final List<String> group;
  final String createdAt;
  final List<User> likedBy;

  Post(
    this.id,
    this.imageName,
    this.category,
    this.title,
    this.creator,
    this.avatarName,
    this.price,
    this.isIncludePos,
    this.group,
    this.createdAt,
    this.likedBy,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageName': imageName,
      'category': category,
      'title': title,
      'creator': creator.toMap(),
      'avatarName': avatarName,
      'price': price,
      'isIncludePos': isIncludePos,
      'group': group,
      'createdAt': createdAt,
      'likedBy': likedBy.map((x) => x.toMap()).toList(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      map['id'] ?? '',
      map['imageName'] ?? '',
      List.from(map['category']),
      map['title'] ?? '',
      User.fromMap(map['creator']),
      map['avatarName'] ?? '',
      map['price'] ?? '',
      map['isIncludePos'] ?? false,
      List<String>.from(map['group']),
      map['createdAt'] ?? '',
      List<User>.from(map['likedBy']?.map((x) => User.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      json['_id'] ?? json['id'] ?? '',
      json['imageName'] ?? '',
      List.from(json['category']),
      json['title'] ?? '',
      User.fromJson(json['creator'][0]),
      json['avatarName'] ?? '',
      json['price'] ?? '',
      json['isIncludePos'] ?? false,
      List<String>.from(json['group']),
      json['createdAt'] ?? '',
      List<User>.from(json['likedBy']?.map((x) => User.fromJson(x))),
    );
  }

  Post copyWith({
    String? id,
    String? imageName,
    List? category,
    String? title,
    User? creator,
    String? avatarName,
    String? price,
    bool? isIncludePos,
    List<String>? group,
    String? createdAt,
    List<User>? likedBy,
  }) {
    return Post(
      id ?? this.id,
      imageName ?? this.imageName,
      category ?? this.category,
      title ?? this.title,
      creator ?? this.creator,
      avatarName ?? this.avatarName,
      price ?? this.price,
      isIncludePos ?? this.isIncludePos,
      group ?? this.group,
      createdAt ?? this.createdAt,
      likedBy ?? this.likedBy,
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, imageName: $imageName, category: $category, title: $title, creator: $creator, avatarName: $avatarName, price: $price, isIncludePos: $isIncludePos, group: $group, createdAt: $createdAt, likedBy: $likedBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.id == id &&
        other.imageName == imageName &&
        listEquals(other.category, category) &&
        other.title == title &&
        other.creator == creator &&
        other.avatarName == avatarName &&
        other.price == price &&
        other.isIncludePos == isIncludePos &&
        listEquals(other.group, group) &&
        other.createdAt == createdAt &&
        listEquals(other.likedBy, likedBy);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imageName.hashCode ^
        category.hashCode ^
        title.hashCode ^
        creator.hashCode ^
        avatarName.hashCode ^
        price.hashCode ^
        isIncludePos.hashCode ^
        group.hashCode ^
        createdAt.hashCode ^
        likedBy.hashCode;
  }
}
