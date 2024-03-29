// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TodoListModel {
  String title;
  bool isDone;
  TodoListModel({
    required this.title,
    required this.isDone,
  });

  TodoListModel copyWith({
    String? title,
    bool? isDone,
  }) {
    return TodoListModel(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isDone': isDone,
    };
  }

  factory TodoListModel.fromMap(Map<String, dynamic> map) {
    return TodoListModel(
      title: map['title'] as String,
      isDone: map['isDone'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoListModel.fromJson(String source) => TodoListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TodoListModel(title: $title, isDone: $isDone)';

  @override
  bool operator ==(covariant TodoListModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.isDone == isDone;
  }

  @override
  int get hashCode => title.hashCode ^ isDone.hashCode;
}
