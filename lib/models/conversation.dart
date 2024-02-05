import 'package:flutter/foundation.dart' show immutable;

import 'package:mychatapp/models/user.dart';

@immutable
class Conversation {
  final String id;
  final List<String> participantIds;
  final bool isTrusted;
  final List<UserModel> participantData;
  const Conversation({
    required this.id,
    required this.participantIds,
    required this.isTrusted,
    required this.participantData,
  });

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    bool? isTrusted,
    List<UserModel>? participantData,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      isTrusted: isTrusted ?? this.isTrusted,
      participantData: participantData ?? this.participantData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'participants': participantIds,
      'isTrusted': isTrusted,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      participantIds: (map['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isTrusted: map['isTrusted'] as bool,
      participantData: List<UserModel>.from(
        (map['expand']['participants'] as List<Map<String, dynamic>>)
            .map<UserModel>(
          (x) => UserModel.fromMap(x),
        ),
      ),
    );
  }
  @override
  String toString() {
    return 'Conversation(id: $id, participantIds: $participantIds, isTrusted: $isTrusted, participantData: $participantData)';
  }

  @override
  bool operator ==(covariant Conversation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.participantIds == participantIds &&
        other.isTrusted == isTrusted &&
        other.participantData == participantData;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        participantIds.hashCode ^
        isTrusted.hashCode ^
        participantData.hashCode;
  }
}
