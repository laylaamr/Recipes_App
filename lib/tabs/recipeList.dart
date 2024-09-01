import 'package:flutter/material.dart';
import 'package:recipe_app/tabs/recipeDetails.dart';
import 'package:recipe_app/widget/costumAppBar.dart';
import 'package:recipe_app/service/RecipeApi.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/service/dp_helper.dart';

import '../models/RecipeDetails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Recipelist(),
    );
  }
}

class Recipelist extends StatefulWidget {
  const Recipelist({super.key});

  @override
  State<Recipelist> createState() => _RecipelistState();
}

class _RecipelistState extends State<Recipelist> {
  bool isFavorite = false;
  RecipeApi recipeApi = RecipeApi();
  RecipeProvider db = RecipeProvider();

  Future<List<Recipemodel>> getAllrecipe() async {
    List<Recipemodel> recipes = [];
    final result = await recipeApi.getAllrecipe();
    for (var item in result["results"]) {
      recipes.add(Recipemodel.fromjson(item));
    }
    return recipes;
  }

  Future<bool> _checkIfFavorite(int id) async {
    try {
      final favorites = await db.getrecipe();
      return favorites.any((recipe) => recipe.id == id);
    } catch (e) {
      print("Error checking if favorite: $e");
      return false;
    }
  }

  Future<void> _toggleFavorite(Recipemodel recipemodel) async {
    try {
      if (await _checkIfFavorite(recipemodel.id)) {
        await db.delete(recipemodel.id);
      } else {
        await db.insert(recipemodel);
      }
      setState(() {}); // To refresh the UI after toggling favorite
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllrecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CostumAppBar(
        title: "Recipes List",
      ),
      body: FutureBuilder<List<Recipemodel>>(
        future: getAllrecipe(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 1,
                  ),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    Recipemodel recipemodel = snapshot.data![index];
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return RecipeDetails(recipemodel: recipemodel);
                          })).then((value) {
                            setState(() {});
                          });
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.network(
                                  recipemodel.image,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: FutureBuilder<bool>(
                                    future: _checkIfFavorite(recipemodel.id),
                                    builder: (context, favoriteSnapshot) {
                                      if (favoriteSnapshot.hasData) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            onPressed: () async {
                                              await _toggleFavorite(recipemodel);
                                            },
                                            icon: Icon(
                                              favoriteSnapshot.data! ? Icons.favorite : Icons.favorite_border,
                                              color: favoriteSnapshot.data! ? Colors.red : Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                recipemodel.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text(
                  "Recipes are Empty",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 25),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
        },
      ),
    );
  }
}
