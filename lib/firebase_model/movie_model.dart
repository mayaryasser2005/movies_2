class MovieModel {
  int id;
  late String title;
  late String description;
  late String date;
  late String image;
  late bool isDone;

  MovieModel({
    required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.image,
      this.isDone = false});

  MovieModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          date: json['date'],
          image: json['image'],
          isDone: json['isDone'],
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "image": image,
      "isDone": isDone,
    };
  }
}
