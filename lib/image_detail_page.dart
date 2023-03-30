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
        backgroundColor: Colors.black,
        title: Text(image.author),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(image.imageUrl),
            const SizedBox(height: 15),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              color: Colors.grey[100],
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      if (image.description.isNotEmpty)
                        Text(
                          image.description,
                          style: TextStyle(fontSize: 15.0),
                        )
                      else
                        Text(
                          'Description is empty!',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
