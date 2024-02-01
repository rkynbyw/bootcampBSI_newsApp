class News {
  final String imageUrl;
  final String title;
  final String description;
  final String url;
  late bool isFavorite;

  News({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.url,
    required this.isFavorite
  });
}