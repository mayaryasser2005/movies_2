class MovieModel {
  String id;
  late String title;
  late String description;
  late int date;
  late bool isDone;

  MovieModel(
      {this.id = "",
      required this.title,
      required this.description,
      required this.date,
      this.isDone = false});

  MovieModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          date: json['date'],
          isDone: json['isDone'],
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "isDone": isDone,
    };
  }
}
