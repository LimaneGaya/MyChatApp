import 'package:flutter/foundation.dart' show immutable;

@immutable
class UserModel {
  final String id;
  final String collectionId;
  final String collectionName;
  final String username;
  final String avatar;
  final String? name;
  final bool verified;
  final DateTime created;
  final DateTime updated;
  final DateTime? lastSeen;
  const UserModel({
    required this.id,
    required this.collectionId,
    required this.collectionName,
    required this.username,
    required this.avatar,
    this.name,
    required this.verified,
    required this.created,
    required this.updated,
    required this.lastSeen,
  });

  UserModel copyWith({
    String? id,
    String? collectionId,
    String? collectionName,
    String? username,
    String? avatar,
    String? name,
    bool? verified,
    DateTime? created,
    DateTime? updated,
    DateTime? lastSeen,
  }) {
    return UserModel(
      id: id ?? this.id,
      collectionId: collectionId ?? this.collectionId,
      collectionName: collectionName ?? this.collectionName,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      verified: verified ?? this.verified,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'collectionId': collectionId,
      'collectionName': collectionName,
      'username': username,
      'avatar': avatar,
      'name': name,
      'verified': verified,
      'created': created.toString(),
      'updated': updated.toString(),
      'lastSeen': lastSeen?.toString(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      collectionId: map['collectionId'] as String,
      collectionName: map['collectionName'] as String,
      username: map['username'] as String,
      avatar: map['avatar'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      verified: map['verified'] as bool,
      created: DateTime.parse(map['created'] as String),
      updated: DateTime.parse(map['updated'] as String),
      lastSeen: map['lastSeen'] != null && map['lastSeen'] != ''
          ? DateTime.parse(map['lastSeen'] as String)
          : null,
    );
  }
  @override
  String toString() {
    return 'UserModel(id: $id, collectionId: $collectionId, collectionName: $collectionName, username: $username, avatar: $avatar, name: $name, verified: $verified, created: $created, updated: $updated, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.collectionId == collectionId &&
        other.collectionName == collectionName &&
        other.username == username &&
        other.avatar == avatar &&
        other.name == name &&
        other.verified == verified &&
        other.created == created &&
        other.updated == updated &&
        other.lastSeen == lastSeen;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        collectionId.hashCode ^
        collectionName.hashCode ^
        username.hashCode ^
        avatar.hashCode ^
        name.hashCode ^
        verified.hashCode ^
        created.hashCode ^
        updated.hashCode ^
        lastSeen.hashCode;
  }
}
