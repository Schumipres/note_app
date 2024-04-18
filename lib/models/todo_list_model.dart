// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TodoModel {
  String title;
  int isPinned;
  String? description;
  int? id;

  TodoModel({
    required this.title,
    required this.isPinned,
    this.description,
    this.id,
  });

  TodoModel copyWith({
    String? title,
    int? isPinned,
    String? description,
    int? id,
  }) {
    return TodoModel(
      title: title ?? this.title,
      isPinned: isPinned ?? this.isPinned,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isPinned': isPinned,
      'description': description,
      'id': id,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      title: map['title'] as String,
      isPinned: map['isPinned'] as int,
      description:
          map['description'] != null ? map['description'] as String : null,
      id: map['id'] != null ? map['id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TodoModel(title: $title, isPinned: $isPinned, description: $description, id: $id)';
  }

  @override
  bool operator ==(covariant TodoModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.isPinned == isPinned &&
        other.description == description &&
        other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        isPinned.hashCode ^
        description.hashCode ^
        id.hashCode;
  }
}
