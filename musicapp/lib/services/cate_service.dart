
// import 'package:musicapp/models/categories.dart';


// class CategoryService {
//   Future<List<Category>> fetchCategories() async {
//     await Future.delayed(const Duration(seconds: 2)); // Simulate a delay
//     return [
//        Category(
//       id: '1',
//       title: 'Những gì bạn thích',
//      albumIds: ['6', '7', '1', '2', '3', '4', '5'],
//     ),
//     Category(
//       id: '2',
//       title: 'Gợi Ý',
//      albumIds: ['6', '7', '1', '2', '3', '4', '5'],
//     ),
//     Category(
//       id: '3',
//       title: 'BXH',
//       albumIds: ['6', '7', '1', '2', '3', '4', '5'],
//     ),
//       Category(
//       id: '4',
//       title: 'BXH',
//       albumIds: ['6', '7', '1', '2', '3', '4', '5'],
//       )
//     ];
//   }
// }
// class CategoryService {
 
// Future<List<Category>> getCategoriesList(AlbumProvider albumProvider){
// return Future.value(categoriesList(albumProvider));
// }
// }
// List<Category> categoriesList(AlbumProvider albumProvider) {
//   // Get all albums from the provider
//   final List<Album> allAlbums = albumProvider.albums;

//   // Define categories with specific album IDs
//   final categories = [
//     Category(
//       id: '1',
//       title: 'Những gì bạn thích',
//      albumIds: ['6', '7', '1', '2', '3', '4', '5'],
//     ),
//     Category(
//       id: '2',
//       title: 'Gợi Ý',
//      albumIds: ['6', '7', '1', '2', '3', '4', '5'],
//     ),
//     Category(
//       id: '3',
//       title: 'BXH',
//       albumIds: ['6', '7', '1', '2', '3', '4', '5'],
//     ),
//       Category(
//       id: '4',
//       title: 'BXH',
//       albumIds: ['6', '7', '1', '2', '3', '4', '5'],
//     ),
//       Category(
//       id: '5',
//       title: 'BXH',
//       albumIds: ['6', '7', '1', '2', '3', '4', '5'],
//     ),
//       Category(
//       id: '6',
//       title: 'BXH',
//       albumIds: ['6', '7', '1', '2', '3', '4', '5'],
//     ),
//   ];
//   // categories.forEach((category) {
//   //   print(
//   //       'Category ${category.id} Albums: ${category.albums.map((album) => album.albumId).toList()}');
//   // });

//   return categories;
// }
// List<Album> getAlbumsFromIds(List<String> albumIds, AlbumProvider albumProvider) {
//   return albumProvider.albums.where((album) => albumIds.contains(album.albumId)).toList();
// }
// // Function to select albums by IDs
// List<Album> chooseAlbumsById(List<String> ids, List<Album> allAlbums) {
//   return allAlbums.where((album) => ids.contains(album.albumId)).toList();
// }
