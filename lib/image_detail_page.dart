import 'package:flutter/material.dart';
import 'unsplash_image.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';

class ImageDetailPage extends StatelessWidget {
  final UnsplashImage image;

  const ImageDetailPage({Key key = const Key('myKey'), required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(image.author),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PinchZoomImage(
              image: Image.network(image.imageUrl),
            ),
            const SizedBox(height: 15),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              color: Colors.grey[100],
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  image.description,
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
