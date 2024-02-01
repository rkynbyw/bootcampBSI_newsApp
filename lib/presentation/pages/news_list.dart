import 'package:flutter/material.dart';
import 'package:newsapp_project/presentation/pages/favorites_news.dart';
import 'package:newsapp_project/presentation/pages/news_view.dart';
import '../../models/news.dart';
import '../widgets/news_card.dart';
import '../widgets/circle_background.dart';
import '../../data/datasource.dart';
import '../../helper_function.dart';
import 'news_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NewsList extends StatefulWidget {
  final List<News> newsList;  // Pass the newsList as a parameter

  const NewsList({Key? key, required this.newsList}) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {

  late Future<List<News>> newsList;
  late List<String> favoriteNews = [];

  @override
  void initState(){
    super.initState();
    loadFavorites();
    newsList = fetchNews();
  }

  Future<void> loadFavorites() async {
    final box = await Hive.openBox<Map>('favorite_news');
    final urls = box.values.map((fav) => fav["url"]).toList();
    setState(() {
      favoriteNews = urls.cast<String>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Hive.openBox<Map>('favorite_news');
    return FutureBuilder(
        future: newsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var article = snapshot.data![index];
                    bool isArticleFavorite = favoriteNews.contains(article.url);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsViewPage(url : article.url),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.blue[50],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.network(
                                    "${article.imageUrl}",
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,

                                    // Error handling when fail to load photo, set default photo
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                      return Center(
                                        child: Image.network('https://images.unsplash.com/photo-1584432743501-7d5c27a39189?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bmljZSUyMHZpZXd8ZW58MHx8MHx8fDA%3D',
                                            height: 160,
                                            width: double.infinity,
                                            fit: BoxFit.cover),
                                      );
                                    },

                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 15, 25, 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[

                                        TruncatedText(fullText: article.title, fontSize: 24),
                                        Container(
                                          height: 10,
                                        ),
                                        TruncatedText(fullText: article.description, fontSize: 15)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )

                          ,
                          Positioned(
                            top: 12,
                            right: 12,
                            child: CircleIconButton(
                              icon: article.isFavorite ? Icons.favorite : Icons.favorite_border,
                              iconColor:Colors.red,
                              circleColor: Colors.white,
                              onPressed: () async {
                                final box = await Hive.openBox<Map>('favorite_news');
                                setState(() {
                                  article.isFavorite = !article.isFavorite;
                                  if (!isArticleFavorite) {
                                    box.add({
                                      "title": article.title,
                                      "url": article.url,
                                    });
                                    print("Successfully added");
                                  } else {
                                    box.delete(article.url);
                                    print("Successfully deleted");
                                  }
                                  // Perbarui daftar URL favorit
                                  loadFavorites();
                                });
                              },
                            ),
                          ),
                        ],
                      )

                      ,
                    );
                  }),
            );
          }
        });

    // return ListView.separated(
    //     itemCount: newsList.length,
    //     separatorBuilder: (context, index)=> const Divider(),
    //     itemBuilder: (context, index){
    //       return (
    //           Card(
    //             color: Colors.blue[50],
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(8)
    //             ),
    //             clipBehavior: Clip.antiAliasWithSaveLayer,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Image.network(
    //                   newsList[index].imageUrl,
    //                   height: 160,
    //                   width: double.infinity,
    //                   fit: BoxFit.cover,
    //                 ),
    //                 Container(
    //                   padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: <Widget>[
    //                       Text(
    //                         'News Title',
    //                         style: TextStyle(
    //                             fontSize: 24,
    //                             color: Colors.grey[800]
    //                         ),
    //                       ),
    //                       Container(
    //                         height: 10,
    //                       ),
    //                       Text(
    //                         'News Caption',
    //                         style: TextStyle(
    //                             fontSize: 15,
    //                             color: Colors.grey[700]
    //                         ),
    //                       )
    //
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ),
    //           )
    //       );
    //     }
    // );
  }
}
