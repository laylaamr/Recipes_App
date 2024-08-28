import 'package:flutter/material.dart';
import 'package:recipe_app/tabs/recipeDetails.dart';
import 'package:recipe_app/widget/costumAppBar.dart';

import '../models/RecipeModel.dart';
import '../service/dp_helper.dart';

class FavouriteList extends StatefulWidget {
  final Recipemodel recipe;
  const FavouriteList({super.key,required this.recipe});

  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  bool isFavorite=false;
  RecipeProvider recipeProvider = RecipeProvider();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar:const  CostumAppBar(title:"Favourite List ",),
        body: FutureBuilder(
            future: recipeProvider.getrecipe(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 9,
                      mainAxisSpacing: 1,
                    ),
                        itemCount: 10,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: EdgeInsets.all(8),
                            child: InkWell(
                              onTap: (){
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => RecipeDetails()),
                                // );
                              },
                              child: Column(
                                children: [
                                  Stack(children: [
                                    Image.network(
                                      'https://th.bing.com/th/id/OIP.-Ei0NCm3I0gLSDUA16sj4AHaE8?rs=1&pid=ImgDetMain',
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
                                          onPressed: (){},
                                          icon: Icon(
                                            isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: isFavorite ? Colors.red : Colors.white,
                                            size: 30,
                                          ),
                                        ),),)
                                  ],),
                                  const  SizedBox(height: 10,),
                                  const Center(child: Text("Pasta", style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,),)
                                ],
                              ),
                            ),
                          );
                        }


                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "favourite List is Empty",
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
                    ));
              }
            }));
  }
}
