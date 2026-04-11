import 'package:flutter/material.dart';
import 'package:flutter_news_app/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}

//News Api   45abb957086a40dfaad2cb6ce41abf20
//End points  https://newsapi.org/v2/everything?q=bitcoin&apiKey=45abb957086a40dfaad2cb6ce41abf20
//top headlines   https://newsapi.org/v2/top-headlines?country=us&apiKey=45abb957086a40dfaad2cb6ce41abf20