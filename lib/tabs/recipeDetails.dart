import 'package:flutter/material.dart';
import 'package:recipe_app/tabs/favouriteList.dart';
import 'package:recipe_app/widget/costumContainer.dart';
import '../models/RecipeDetails.dart';
import '../models/RecipeModel.dart';
import '../service/RecipeApi.dart';

class RecipeDetails extends StatefulWidget {
  final Recipemodel recipemodel;
  const RecipeDetails({super.key, required this.recipemodel});

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  RecipeApi recipeApi = RecipeApi();

  Future<Recipedetails> getAlldetails() async {
    final result = await recipeApi.getAlldetails(widget.recipemodel.id);
    return Recipedetails.fromjson(result);
  }

  @override
  void initState() {
    super.initState();
    getAlldetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              size: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavouriteList()),
              );
            },
          ),
          Icon(Icons.play_arrow, size: 25),
          SizedBox(width: 5),
          Icon(Icons.shopping_cart, size: 25),
          SizedBox(width: 5),
          Icon(Icons.share, size: 25),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Recipedetails>(
          future: getAlldetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
              );
            } else if (snapshot.hasData) {
              final recipeDetails = snapshot.data!;
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(recipeDetails.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    recipeDetails.title,
                    style: TextStyle(fontSize: 30, color: Color(0xff4A7C74)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomContainer(
                          title: recipeDetails.healthScore.toString(),
                        ),
                        CustomContainer(
                          title: recipeDetails.time.toString(),
                          icon: Icons.timelapse,
                        ),
                        CustomContainer(
                          title: 'Ingredients',
                          icon: Icons.nightlife_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipeDetails.summary,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              );
            } else {
              return const Center(child: Text("No Data"));
            }
          },
        ),
      ),
    );
  }
}
