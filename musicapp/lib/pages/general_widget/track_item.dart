// import 'package:flutter/material.dart';

// import '../../dto/response/song_response.dart';

// /// Reusable TrackItem Widget for Each Song

// class TrackItem extends StatelessWidget {
//   final SongResponse track;

//   const TrackItem({Key? key, required this.track}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Image.network(
//         track.albumImage,
//         width: 50,
//         height: 50,
//         fit: BoxFit.cover,
//       ),
//       title: Text(
//         track.title,
//         style: const TextStyle(color: Colors.white),
//       ),
//       subtitle: Text(
//         track.artistName,
//         style: const TextStyle(color: Colors.white70),
//       ),
//     );
//   }
// }