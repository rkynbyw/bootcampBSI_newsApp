import 'package:flutter/material.dart';
import 'package:newsapp_project/presentation/pages/news_list.dart';
import '../../data/datasource.dart';
import 'favorites_news.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // late TabController _tabController;
  late Set<String> favoriteNews = {};

  void onFavoriteChanged(String url, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        favoriteNews.add(url);
      } else {
        favoriteNews.remove(url);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('News App'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.newspaper), text: 'News List'),
              Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          // controller: _tabController,
          children: [
            // NewsList(newsList: newsList),
            // FavoritesList(),
            NewsList(newsList: newsList),
            FavoritesList(),
          ],
        ),
      ),
    );
  }
}
