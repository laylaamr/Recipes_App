import 'package:flutter/material.dart';
import 'package:recipe_app/tabs/recipeDetails.dart';
import 'package:recipe_app/widget/costumAppBar.dart';
import '../models/RecipeModel.dart';
import '../service/dp_helper.dart';

class FavouriteList extends StatefulWidget {
  const FavouriteList({super.key});

  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  RecipeProvider recipeProvider = RecipeProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CostumAppBar(title: "Favourite List"),
      body: FutureBuilder<List<Recipemodel>>(
        future: recipeProvider.getrecipe(),
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
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 9,
                  mainAxisSpacing: 1,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Recipemodel recipemodel = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      await recipeProvider
                                          .delete(recipemodel.id)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
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
                "Favourite List is Empty",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            );
          }
        },
      ),
    );
  }
}
