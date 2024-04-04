// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TodoListModel {
  String title;
  bool isPinned;
  String? description;
  TodoListModel({
    required this.title,
    required this.isPinned,
    this.description,
  });

  TodoListModel copyWith({
    String? title,
    bool? isPinned,
    String? description,
  }) {
    return TodoListModel(
      title: title ?? this.title,
      isPinned: isPinned ?? this.isPinned,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isPinned': isPinned,
      'description': description,
    };
  }

  factory TodoListModel.fromMap(Map<String, dynamic> map) {
    return TodoListModel(
      title: map['title'] as String,
      isPinned: map['isPinned'] as bool,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoListModel.fromJson(String source) =>
      TodoListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TodoListModel(title: $title, isPinned: $isPinned, description: $description)';

  @override
  bool operator ==(covariant TodoListModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.isPinned == isPinned &&
        other.description == description;
  }

  @override
  int get hashCode => title.hashCode ^ isPinned.hashCode ^ description.hashCode;
}
