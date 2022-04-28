import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;
  final String avatarName;
  final String createdAt;

  User(
    this.id,
    this.username,
    this.email,
    this.avatarName,
    this.createdAt,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarName': avatarName,
      'createdAt': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['id'] ?? '',
      map['username'] ?? '',
      map['email'] ?? '',
      map['avatarName'] ?? '',
      map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'] ?? '',
      json['username'] ?? '',
      json['email'] ?? '',
      json['avatarName'] ?? '',
      json['createdAt'] ?? '',
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, avatarName: $avatarName, createdAt: $createdAt)';
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarName,
    String? createdAt,
  }) {
    return User(
      id ?? this.id,
      username ?? this.username,
      email ?? this.email,
      avatarName ?? this.avatarName,
      createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.avatarName == avatarName &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        avatarName.hashCode ^
        createdAt.hashCode;
  }
}
