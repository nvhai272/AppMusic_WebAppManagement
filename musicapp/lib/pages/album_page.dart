// import 'package:flutter/material.dart';
// import 'package:musicapp/models/album_provider.dart';
// import 'package:provider/provider.dart';
//  // Make sure to import your AlbumProvider file here

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AlbumProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AlbumPage(),
//     );
//   }
// }

// class AlbumPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Albums'),
//       ),
//       body: Consumer<AlbumProvider>(
//         builder: (context, albumProvider, child) {
//           final albums = albumProvider.albums;
//           return ListView.builder(
//             itemCount: albums.length,
//             itemBuilder: (context, index) {
//               final album = albums[index];
//               return ListTile(
//                 leading: Image.asset(
//                   album.albumArt,
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                 ),
//                 title: Text(album.title),
//                 subtitle: Text(album.artistName),
//                 onTap: () {
//                   albumProvider.selectAlbum(album.albumId);
//                   // Navigate to album details or song list
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AlbumDetailsPage(albumId: album.albumId),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class AlbumDetailsPage extends StatelessWidget {
//   final String albumId;

//   AlbumDetailsPage({required this.albumId});

//   @override
//   Widget build(BuildContext context) {
//     final album = context
//         .read<AlbumProvider>()
//         .albums
//         .firstWhere((album) => album.albumId == albumId);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(album.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               album.albumArt,
//               width: 200,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 20),
//             Text(
//               album.title,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               album.artistName,
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
