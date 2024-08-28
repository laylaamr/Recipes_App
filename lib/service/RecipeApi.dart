import 'package:dio/dio.dart';
import 'EndPoints.dart';
class RecipeApi {
  final String _baseurl = "https://api.spoonacular.com/recipes/";
  Dio _dio = Dio();
  Future<Map<String, dynamic>> getAllrecipe() async {
    Response response = await _dio.get('$_baseurl${Endpoints.recipe}' ,queryParameters: {
      "apiKey":"919661c37b7342ea83c017af2cb97478",
    });
    return response.data;
  }
  Future<Map<String, dynamic>> getAlldetails(int id) async {
    Response response = await _dio.get('$_baseurl$id/${Endpoints.details}' ,queryParameters: {
      "apiKey":"919661c37b7342ea83c017af2cb97478",
    });
    return response.data;
  }
}