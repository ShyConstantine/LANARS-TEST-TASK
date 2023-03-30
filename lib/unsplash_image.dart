class UnsplashImage {
  final String imageUrl;
  final String smallUrl;
  final String author;
  final String description;

  UnsplashImage(
      {required this.imageUrl,
      this.smallUrl = '',
      this.author = '',
      this.description = ''});
}
