// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/song_provider.dart';
// import '../../dto/response/song_response.dart';
// import '../../services/api/song_api.dart';

// class LikeButton extends StatelessWidget {
//   final SongResponse track;
//   final SongApi songApi;

//   const LikeButton({
//     Key? key,
//     required this.track,
//     required this.songApi,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<SongProvider>(
//       builder: (context, songProvider, child) {
//         if (track == null) {
//           return const Center(child: Text("Track data is unavailable."));
//         }

//         // Check if songApi is null
//         if (songApi == null) {
//           return const Center(child: Text("Song API is unavailable."));
//         }

//         return ListTile(
//           leading: Icon(
//             songProvider.isLiked(track.id)
//                 ? Icons.favorite
//                 : Icons.favorite_border,
//             color: Colors.white,
//           ),
//           title: Text(
//             songProvider.isLiked(track.id)
//                 ? "Remove from Liked Songs"
//                 : "Add to Liked Songs",
//             style: const TextStyle(color: Colors.white),
//           ),
//           onTap: () {
//             final songId = track.id;

//             // Ensure songId is not null
//             if (songId == null) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Song ID is unavailable.")),
//               );
//               return;
//             }

//             songProvider.toggleLikeStatus(
//               context,
//               (ctx, request) async {
//                 await songApi.likeSong(ctx, request);
//               },
//               (ctx, request) async {
//                 await songApi.unlikeSong(ctx, request);
//               },
//               songId,
//             );
//           },
//         );
//       },
//     );
//   }
// }
