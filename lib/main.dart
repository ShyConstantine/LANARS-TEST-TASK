import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'unsplash_image.dart';
import 'image_detail_page.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unsplash Images',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Unsplash Images'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key key = const Key('myKey'), this.title = 'Unsplash Images'})
      : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UnsplashImage> _images = [];
  List _imagesList = [];
  String _query = '';

  Future<void> _refreshData(String query) async {
    final dio = Dio();
    var newImages = <UnsplashImage>[];
    for (var i = 0; i < _images.length; i++) {
      var imageUrl = _images[i].imageUrl;
      var response = await dio.get(imageUrl);
      newImages.add(UnsplashImage(
        imageUrl: response.data.toString(),
        author: '',
        description: '',
        smallUrl: '',
      ));
    }
    setState(() {
      _images = newImages;
    });
    if (query.isEmpty) {
      await _getImages();
    } else {
      await _searchImages(query);
    }
  }

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getImages();
  }

  Future<void> _getImages() async {
    final dio = Dio();
    setState(() {
      _loading = true;
    });

    final response = await dio.get(
        'https://api.unsplash.com/photos?client_id=k8lg1KnkREvSThSb870MZM9IV344kl82VMFlScKMPvM&per_page=30');

    if (response.statusCode == 200) {
      setState(() {
        _imagesList = json.decode(response.data);
        _loading = false;
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<void> _searchImages(String query) async {
    setState(() {
      _loading = true;
      String _query = query;
    });

    final dio = Dio();
    final response = await dio.get(
        'https://api.unsplash.com/photos?client_id=k8lg1KnkREvSThSb870MZM9IV344kl82VMFlScKMPvM&per_page=30');
    if (response.statusCode == 200) {
      setState(() {
        _imagesList = json.decode(response.data)['results'];
        _loading = false;
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  void _resetSearch() {
    setState(() {
      _query = '';
    });
    _getImages();
  }

// Віджет поля пошуку
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search at Unsplash',
        prefixIcon: Icon(Icons.search),
        suffixIcon: _query.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: _resetSearch,
              )
            : null,
      ),
      onChanged: (value) {
        _searchImages(value);
      },
    );
  }

  Widget _buildImageTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageDetailPage(
              image: UnsplashImage(
                imageUrl: _imagesList[index]['urls']['regular'],
                author: _imagesList[index]['user']['name'] ?? '',
                description: _imagesList[index]['description'] ?? '',
              ),
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: _imagesList[index]['urls']['thumb'],
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(_query),
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (value) => setState(() {
                _query = value;
              }),
              onSubmitted: (value) => _refreshData(value),
            ),
          ),
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              itemCount: _imagesList.length,
              itemBuilder: _buildImageTile,
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
            ),
          ),
        ]),
      ),
    );
  }
}
