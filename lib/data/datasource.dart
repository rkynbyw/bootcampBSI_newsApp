import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/news.dart';
// import 'package:hive/hive.dart';

List<News> favoriteNewsList = [];
List<News> newsList = [];

Future<List<News>> fetchNews() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/everything?q=keyword&apiKey=4b397c0b925c48649a61b00c6ab69622'));

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    List<News> newsList = [];
    // var favoriteNewsBox = Hive.box<News>('favoriteNews');
    for (var item in jsonResponse['articles']) {
      var news = News(
        imageUrl: item['urlToImage'] ?? 'default_image_url',
        title: item['title'] ?? 'default_title',
        description: item['description'] ?? 'default_description',
        url: item['url'] ?? 'default_url',
        isFavorite: false
      );
      // news.isFavorite = favoriteNewsBox.values
      //     .any((favoriteNews) => favoriteNews.title == news.title);
      newsList.add(news);
      // print(newsList);
      if (newsList.length == 10) {
        break;
      }
    }
    return newsList;
  } else {
    throw Exception('Failed to load news');
  }
}