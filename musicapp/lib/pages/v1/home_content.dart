// import 'package:flutter/material.dart';
// // Ensure this file exists
// import 'package:musicapp/providers/album_provider.dart'; // Ensure this file exists
// import 'package:provider/provider.dart';

// import '../models/categories.dart';

// // void main() {
// //   runApp(
// //     MultiProvider(
// //       providers: [
// //         ChangeNotifierProvider(
// //           create: (_) => AlbumProvider(), // Wrap the app with AlbumProvider
// //         ),
// //       ],
// //       child: MyApp(),
// //     ),
// //   );
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: HomeContent(),
// //     );
// //   }
// // }

// class HomeContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.black, Color.fromARGB(255, 219, 4, 76)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Consumer<AlbumProvider>(
//           builder: (context, albumProvider, child) {
//             List<Category> categories = categoriesList(albumProvider);
//             return ListView.builder(
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 final category = categories[index];

//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Category Title
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             category.title,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               // Handle "see more" action here
//                             },
//                             child: const Text(
//                               'xem thêm',
//                               style:
//                                   TextStyle(color: Colors.blue, fontSize: 14),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),

//                       // Album Horizontal List
//                       SizedBox(
//                         height: 120,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount:
//                                category.albumIds.length,
//                                 // category.albums.length,// Display all albums
//                           itemBuilder: (context, albumIndex) {
//                             final albums = getAlbumsFromIds(
//                                 category.albumIds, albumProvider);
//                             final album = albums[albumIndex];
//                             // List<Album> albums = albumProvider.albums;
//                             // final Album album = category.albums[albumIndex];
//                             // print('Rendering album: ${album.albumId}');
//                             return Padding(
//                               padding: const EdgeInsets.only(right: 8.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   // Handle album tap here
//                                 },
//                                 child: Container(
//                                   width: 100,
//                                   decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                       image: AssetImage(album.albumArt),
//                                       fit: BoxFit.cover,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Container(
//                                     alignment: Alignment.bottomCenter,
//                                     padding: const EdgeInsets.all(4.0),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Text(
//                                       album.artistName,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
