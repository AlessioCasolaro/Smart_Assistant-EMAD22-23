class Task {
  final String title;
  final String description;

  Task(this.title, this.description);

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}
