import 'Ingrediants.dart';

class Recipedetails {
  final int time, healthScore;
  final String summary, image, title;
  final List<Ingredients> extendedIngredients;

  Recipedetails({
    required this.image,
    required this.title,
    required this.extendedIngredients,
    required this.summary,
    required this.healthScore,
    required this.time,
  });

  factory Recipedetails.fromjson(Map<String, dynamic> json) {
    return Recipedetails(
      image: json['image'] ?? '', // Default to an empty string if null
      title: json['title'] ?? '',
      extendedIngredients: (json["extendedIngredients"] as List<dynamic>?)
          ?.map((item) => Ingredients.fromjson(item))
          .toList() ??
          [],
      summary: json['summary'] ?? '',
      healthScore: json['healthScore'] ?? 0, // Default to 0 if null
      time: json['time'] ?? 0, // Default to 0 if null
    );
  }
}
