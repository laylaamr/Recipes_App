class Recipemodel {
  final int id;
  final String title, image;

  Recipemodel({required this.id, required this.title, required this.image});
  factory Recipemodel.fromjson(Map<String, dynamic> json) {
    return Recipemodel(
        id: json["id"], title: json["title"], image: json["image"]);
  }
  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "image": image};
  }
}