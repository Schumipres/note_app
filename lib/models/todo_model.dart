class Todo {
  final String name;
  final DateTime createdTime;

  Todo({required this.name, required this.createdTime});

  @override
  String toString() {
    return 'Todo{name: $name, createdTime: $createdTime}';
  }
  
}
