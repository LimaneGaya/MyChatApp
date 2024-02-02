import 'package:flutter/foundation.dart';
import 'package:mychatapp/services/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart';

@immutable
class Message {
  final RecordModel rm;
  final String id;
  final DateTime created;
  final DateTime updated;
  final String conversation;
  final String sender;
  final String content;
  final bool isEdited;
  final List<String> file;
  const Message({
    required this.rm,
    required this.id,
    required this.created,
    required this.updated,
    required this.conversation,
    required this.sender,
    required this.content,
    required this.isEdited,
    required this.file,
  });

  Message copyWith({
    RecordModel? rm,
    String? id,
    DateTime? created,
    DateTime? updated,
    String? conversation,
    String? sender,
    String? content,
    bool? isEdited,
    List<String>? file,
  }) {
    return Message(
      id: id ?? this.id,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      conversation: conversation ?? this.conversation,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      isEdited: isEdited ?? this.isEdited,
      file: file ?? this.file,
      rm: rm ?? this.rm,
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
      'file': file,
    };
  }

  factory Message.fromMap(RecordModel rm) {
    final map = rm.toJson();
    return Message(
      rm: rm,
      id: map['id'] as String,
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
      conversation: map['conversation'] as String,
      sender: map['sender'] as String,
      content: map['content'] as String,
      isEdited: (map['isEdited'] as bool?) ?? false,
      file: map['file'] != null
          ? List<String>.from(map['file']).map((e) => PB.getUrl(rm, e)).toList()
          : [],
    );
  }
  @override
  String toString() {
    return 'Message(id: $id, created: $created, updated: $updated, conversation: $conversation, sender: $sender, content: $content, isEdited: $isEdited, file: $file)';
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
        listEquals(other.file, file);
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
        file.hashCode;
  }
}
