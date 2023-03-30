import 'package:flutter/material.dart';
import 'unsplash_image.dart';

class ImageDetailPage extends StatelessWidget {
  final UnsplashImage image;

  const ImageDetailPage({Key key = const Key('myKey'), required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(image.author),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(image.imageUrl),
            SizedBox(height: 16),
            Text(image.description),
          ],
        ),
      ),
    );
  }
}
