import 'package:flutter/material.dart';
import '../../models/album.dart'; // Import your Album model

class AlbumProvider extends ChangeNotifier {
  // List of albums
  // final List<Album> _albums = [
  //   Album(
  //     albumId: '1',
  //     title: 'JVKE albums',
  //     artistName: 'JVKE',
  //     albumArt: 'assets/images/6.jpg',
  //   ),
  //   Album(
  //     albumId: '2',
  //     title: 'Melancholy',
  //     artistName: 'John Doe',
  //     albumArt: 'assets/images/5.jpg',
  //   ),
  //   Album(
  //     albumId: '3',
  //     title: 'Serenity',
  //     artistName: 'Jane Smith',
  //     albumArt: 'assets/images/4.jpg',
  //   ),
  //   Album(
  //     albumId: '4',
  //     title: 'Waves of Joy',
  //     artistName: 'Emily Rose',
  //     albumArt: 'assets/images/3.jpg',
  //   ),
  //   Album(
  //     albumId: '5',
  //     title: 'Limbo',
  //     artistName: 'KESHI',
  //     albumArt: 'assets/images/2.webp',
  //   ),
  //     Album(
  //     albumId: '6',
  //     title: 'The memories museum',
  //     artistName: 'VU.',
  //     albumArt: 'assets/images/musicix2.png',
  //   ),
  //   Album(
  //     albumId: '7',
  //     title: 'Everyone has to start somewhere',
  //     artistName: 'HIEUTHUHAI',
  //     albumArt: 'assets/images/2.jpg',
  //   ),
  // ];

  // Getter to access the albums
  // List<Album> get albums => _albums;

  // // Selected album for details or playback
  // Album? _selectedAlbum;

  // Album? get selectedAlbum => _selectedAlbum;
  // List<Album> getAlbumsFromIds(List<int> ids) {
  //   return _albums.where((album) => ids.contains(album.albumId)).toList();
  // }

}
