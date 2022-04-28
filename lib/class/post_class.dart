import 'dart:convert';
import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String imageName;
  final List category;
  final String title;
  final String creator;
  final String avatarName;
  final String price;
  final bool isIncludePos;
  final List group;
  final String createdAt;

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
      this.createdAt);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageName': imageName,
      'category': category,
      'title': title,
      'creator': creator,
      'avatarName': avatarName,
      'price': price,
      'isIncludePos': isIncludePos,
      'group': group,
      'createdAt': createdAt,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      map['id'] ?? '',
      map['imageName'] ?? '',
      List.from(map['category']),
      map['title'] ?? '',
      map['creator'] ?? '',
      map['avatarName'] ?? '',
      map['price'] ?? '',
      map['isIncludePos'] ?? false,
      List.from(map['group']),
      map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      json['id'] ?? '',
      json['imageName'] ?? '',
      List.from(json['category']),
      json['title'] ?? '',
      json['creator'] ?? '',
      json['avatarName'] ?? '',
      json['price'] ?? '',
      json['isIncludePos'] ?? false,
      List.from(json['group']),
      json['createdAt'] ?? '',
    );
  }

  Post copyWith({
    String? id,
    String? imageName,
    List? category,
    String? title,
    String? creator,
    String? avatarName,
    String? price,
    bool? isIncludePos,
    List? group,
    String? createdAt,
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
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, imageName: $imageName, category: $category, title: $title, creator: $creator, avatarName: $avatarName, price: $price, isIncludePos: $isIncludePos, group: $group, createdAt: $createdAt)';
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
        other.createdAt == createdAt;
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
        createdAt.hashCode;
  }
}
