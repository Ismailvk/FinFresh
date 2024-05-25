class TodoModel {
  String? id;
  String? title;
  String? description;

  TodoModel({this.id, required this.title, required this.description});
  factory TodoModel.fromJson(json) {
    return TodoModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
    );
  }
  static Map<String, dynamic> toJson(TodoModel todoObj) => {
        'title': todoObj.title,
        'description': todoObj.description,
        '_id': todoObj.id
      };
}
