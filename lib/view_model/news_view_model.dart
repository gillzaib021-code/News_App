// import 'package:flutter_news_app/models/categories_news_model.dart';
// import 'package:flutter_news_app/models/news_channel_headlines_model.dart';
// import 'package:flutter_news_app/repository/news_repository.dart';

// class NewsViewModel {

//   final _rep=NewsRepository();

//   Future <NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi ({required String name}) async{
//      final response= await  _rep.fetchNewsChannelHeadlinesApi();
//      return response;
//   }


//    Future <CategoriesNewsModel> fetchCategoriesNewsApi (String category) async{
//      final response= await  _rep.fetchCategoriesNewsApi(category);
//      return response;
//   }
  
// }

// In your news_repository.dart file

import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/news_channel_headlines_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsViewModel {
  
  // FIXED: Accept the 'name' parameter and use it in the API URL
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi({required String name}) async {
    // Use the 'name' parameter in the URL
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/top-headlines?sources=$name&apiKey=45abb957086a40dfaad2cb6ce41abf20')
    );
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load news for channel: $name');
    }
  }
  
  // This function remains the same
  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await http.get(
      Uri.parse('https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=45abb957086a40dfaad2cb6ce41abf20')
    );
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load category news');
    }
  }
}