class Ingredients {
  final int id;
  final String name, image;

  Ingredients({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Ingredients.fromjson(Map<String, dynamic> json) {
    return Ingredients(
      id: json["id"] ?? 0, // Default to 0 if null
      name: json["name"] ?? '', // Default to an empty string if null
      image: json["image"] ?? '', // Default to an empty string if null
    );
  }
}
