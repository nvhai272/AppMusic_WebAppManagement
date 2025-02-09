// import 'package:flutter/material.dart';
// // Ensure this file exists
// import 'package:musicapp/models/album_provider.dart'; // Ensure this file exists
// import 'package:musicapp/pages/home_content-viewer.dart';
// import 'package:provider/provider.dart';

// import '../models/categories.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => AlbumProvider(), // Wrap the app with AlbumProvider
//         ),
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
//       home: HomeContent(),
//     );
//   }
// }

// class HomeContent extends StatelessWidget {
//   var categoryService = CategoryService();
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(future: categoryService.getCategoriesList(albumProvider), builder: (ct, snap) {
        
//         return HomeContentViewer(categories: snap.data!));
//       }),
//       // bodydd: HomeContentViewer(categories: categoriesList(albumProvider))
//     );
//   }
// }
