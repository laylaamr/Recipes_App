import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:recipe_app/models/RecipeModel.dart';


final String ColumnId = "id";
final String ColumnImage = "image";
final String ColumnTitle = "title";
final String recipetable = "recipe_table";

class RecipeProvider {
  static final RecipeProvider instance = RecipeProvider._internal();

  factory RecipeProvider() {
    return instance;
  }

  RecipeProvider._internal();

  Database? db;
  Map<int, bool> isfavourite = {};

  Future open() async {
    if (db != null) return;
    db = await openDatabase(
      join(await getDatabasesPath(), "recipe.db"),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $recipetable($ColumnId INTEGER PRIMARY KEY, $ColumnTitle TEXT NOT NULL, $ColumnImage TEXT NOT NULL)",
        );
      },
    );
  }

  Future<Recipemodel> insert(Recipemodel recipe) async {
    await open(); // Ensure the database is open
    await db!.insert(recipetable, recipe.toMap());
    return recipe;
  }

  Future<List<Recipemodel>> getrecipe() async {
    await open(); // Ensure the database is open
    final result = await db!.query(recipetable);
    List<Recipemodel> recipes = result.map((item) {
      isfavourite[item['id'] as int] = true;
      return Recipemodel.fromjson(item);
    }).toList();
    return recipes;
  }

  Future<int> delete(int id) async {
    await open(); // Ensure the database is open
    isfavourite[id] = false;
    return await db!.delete(recipetable, where: "$ColumnId=?", whereArgs: [id]);
  }
}
