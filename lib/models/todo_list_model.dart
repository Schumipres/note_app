// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TodoListModel {
  String title;
  bool isDone;
  String? description;
  TodoListModel({
    required this.title,
    required this.isDone,
    this.description,
  });

  TodoListModel copyWith({
    String? title,
    bool? isDone,
    String? description,
  }) {
    return TodoListModel(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isDone': isDone,
      'description': description,
    };
  }

  factory TodoListModel.fromMap(Map<String, dynamic> map) {
    return TodoListModel(
      title: map['title'] as String,
      isDone: map['isDone'] as bool,
      description: map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoListModel.fromJson(String source) => TodoListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TodoListModel(title: $title, isDone: $isDone, description: $description)';

  @override
  bool operator ==(covariant TodoListModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.isDone == isDone &&
      other.description == description;
  }

  @override
  int get hashCode => title.hashCode ^ isDone.hashCode ^ description.hashCode;
}
