import 'dart:convert';

import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/news_channel_headlines_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi () async {
    
     String url='https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=45abb957086a40dfaad2cb6ce41abf20';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode==200) {
      final body=jsonDecode(response.body);
     return NewsChannelHeadlinesModel.fromJson(body); 
    }
    throw Exception('Api Error');
  }



 

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {

  String url = 'https://newsapi.org/v2/everything?q=$category&apiKey=45abb957086a40dfaad2cb6ce41abf20';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    return CategoriesNewsModel.fromJson(body);
  }

  throw Exception('Api Error');
}
}