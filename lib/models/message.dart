// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart';

@immutable
class Message {
  final String id;
  final DateTime created;
  final DateTime updated;
  final String conversation;
  final String sender;
  final String content;
  final bool isEdited;
  final List<String> files;
  const Message({
    required this.id,
    required this.created,
    required this.updated,
    required this.conversation,
    required this.sender,
    required this.content,
    required this.isEdited,
    required this.files,
  });

  Message copyWith({
    String? id,
    DateTime? created,
    DateTime? updated,
    String? conversation,
    String? sender,
    String? content,
    bool? isEdited,
    List<String>? files,
  }) {
    return Message(
      id: id ?? this.id,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      conversation: conversation ?? this.conversation,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      isEdited: isEdited ?? this.isEdited,
      files: files ?? this.files,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
      'conversation': conversation,
      'sender': sender,
      'content': content,
      'isEdited': isEdited,
      'files': files,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
      conversation: map['conversation'] as String,
      sender: map['sender'] as String,
      content: map['content'] as String,
      isEdited: (map['isEdited'] as bool?) ?? false,
      files: map['files'] != null ? List<String>.from(map['files']) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, created: $created, updated: $updated, conversation: $conversation, sender: $sender, content: $content, isEdited: $isEdited, files: $files)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.created == created &&
        other.updated == updated &&
        other.conversation == conversation &&
        other.sender == sender &&
        other.content == content &&
        other.isEdited == isEdited &&
        listEquals(other.files, files);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        created.hashCode ^
        updated.hashCode ^
        conversation.hashCode ^
        sender.hashCode ^
        content.hashCode ^
        isEdited.hashCode ^
        files.hashCode;
  }
}
