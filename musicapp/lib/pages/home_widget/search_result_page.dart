import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dto/response/album_response.dart';
import '../../providers/album_provider.dart';
import '../../providers/user_provider.dart';
import 'album_page.dart';

class SearchResult extends StatelessWidget {
  String txtSearch;
  SearchResult({super.key, required this.txtSearch});

  final TextEditingController _txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
 

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlbumProvider>(context, listen: false)
          .searchAlbumByKeyword(txtSearch, context);
    });

    return Scaffold(
        body: Stack(children: [
      Container(
        // Gradient container
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 62, 62, 62),
              Color.fromARGB(255, 0, 0, 0)
            ],
          ),
        ),
      ),
      Padding(
          // Padding on top of the gradient
          padding: const EdgeInsets.only(
            top: 50.0,
            left: 25.0,
            right: 25.0,
            bottom: 50.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: Colors.white,),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 280, // Adjust the width as needed
                    height: 40, // Adjust the height as needed
                    child: _buildSearchField(context),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Consumer<AlbumProvider>(
                builder: (context, albumProvider, child) {
                  if (albumProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (albumProvider.albumList.isEmpty) {
                    return Center(child: Text('No items found.',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),));
                  } else {
                    return _buildSearchResults(context, albumProvider);
                  }
                },
              ),
            ],
          ))
    ]));
  }

  Widget _buildSearchResults(
      BuildContext context, AlbumProvider albumProvider) {
    return Expanded(
      child: GridView.builder(
        itemCount: albumProvider.albumList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 15,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return _renderItems(context, albumProvider.albumList[index]);
        },
      ),
    );
  }

// Build the search field
  Widget _buildSearchField(BuildContext context) {
    return TextField(
        controller: _txtSearch,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 255, 255, 255),
          hintStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          hintText: '${txtSearch}',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
            size: 30,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Color(0xFF87AFC7),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        onChanged: (keyword) {
          if (keyword.isNotEmpty) {
            // Trigger the search when the user types in the search field
            Provider.of<AlbumProvider>(context, listen: false)
                .searchAlbumByKeyword(keyword, context);
          } else {
            // Clear the list when the query is empty
            Provider.of<AlbumProvider>(context, listen: false).clearAlbums();
          }
        });
  }

  Widget _renderItems(BuildContext context, AlbumResponse album) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => goToAlbum(context, album),
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white, // Specify the border color
                width: 2.0, // Specify the border width
              ),
              // color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Container(
              width: 90,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'http://localhost:8080/api/files/download/image/${album.image}'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          album.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'San Francisco',
          ),
        ),
      ],
    );
  }

  void goToAlbum(BuildContext context, AlbumResponse album) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlbumPage(
                  album: album,
                )));
  }
}
