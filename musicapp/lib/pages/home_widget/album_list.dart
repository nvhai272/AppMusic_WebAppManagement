import 'package:flutter/material.dart';
import 'package:musicapp/dto/response/album_response.dart';

import 'album_page.dart';

class HorizontalAlbumList extends StatelessWidget {
  final List<AlbumResponse> albums;

  const HorizontalAlbumList({
    required this.albums,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
       height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumPage(album: album),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Prevent overflow
                crossAxisAlignment: CrossAxisAlignment.center, // Align text properly
                children: [
                  // Container with the image
                  Container(
                    width: 150,
                    height: 120, // Ensure a height for the container
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'http://localhost:8080/api/files/download/image/${album.image!}'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Text outside the image container, make sure text doesn't overflow
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0), // Adjust spacing as needed
                    child: Text(
                      album.artistName!,
                      maxLines: 1, // Limit the text to one line
                      overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                      style: const TextStyle(
                        color: Colors.white, // Change color based on your theme
                        fontSize: 12, // Reduce font size if necessary
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
//       height: 120,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: albums.length,
//         itemBuilder: (context, index) {
//           final album = albums[index];

//           return Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AlbumPage(album: album),
//                   ),
//                 );
//               },
//               child: Column(
//                 children: [
//                   // Container with the image
//                   Container(
//                     width: 150,
//                     height: 99, // Ensure a height for the container
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: NetworkImage(
//                             'http://localhost:8080/api/files/download/image/${album.image!}'),
//                         fit: BoxFit.cover,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),

//                   // Text outside the image container
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         top: 1.0), // Adjust spacing as needed
//                     child: Text(
//                       album.artistName!,
//                       style: const TextStyle(
//                         color: Colors.white, // Change color based on your theme
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//               child: Container(
//                 width: 150,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage('http://localhost:8080/api/files/download/image/${album.image!}'),
//                     fit: BoxFit.cover,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Container(
//                   alignment: Alignment.bottomCenter,
//                   padding: const EdgeInsets.all(4.0),
//                   child: Text(
//                     album.artistName!,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
