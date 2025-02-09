import 'package:flutter/material.dart';
import 'package:musicapp/pages/song_page.dart';
import 'package:musicapp/providers/song_provider.dart';
import 'package:provider/provider.dart';
import '../../dto/response/song_response.dart';
import '../../services/api/song_api.dart';

/// Reusable PopularTracksList Widget
class PopularTracksList extends StatelessWidget {
  final List<SongResponse> tracks;

  const PopularTracksList({Key? key, required this.tracks}) : super(key: key);

  void goToSong(BuildContext context, int songIndex) {
    // Access PlaylistProvider
    final playlistProvider = Provider.of<SongProvider>(context, listen: false);

    // Update current song index in PlaylistProvider
    playlistProvider.currentSongIndex = songIndex;
    playlistProvider.play(isCalledFromUI: false);
    // Navigate to SongPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tracks.length,
      separatorBuilder: (context, index) => const Divider(
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      itemBuilder: (context, index) {
        final track = tracks[index];

        return Card(
          color: Colors.black, // Card color
          margin: const EdgeInsets.symmetric(
              vertical: 0, horizontal: 0), // Space around cards
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          elevation: 4, // Card shadow effect
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.5), // Bottom border color
                  width: 1.0, // Bottom border width
                ),
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.all(8), // Padding inside the card
              leading: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8), // Rounded corners for image
                child: Image.network(
                  'http://localhost:8080/api/files/download/image/${track.albumImage}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                track.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                track.artistName,
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
                onPressed: () {
                  // Display options or perform actions
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildOptionsMenu(track, context),
                  );
                },
              ),
              onTap: () => goToSong(context, index),
            ),
          ),
        );
      },
    );
  }
}

// Widget _buildOptionsMenu(SongResponse track) {
//   return Container(
//     color: Colors.black,
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ListTile(
//           leading: const Icon(Icons.play_arrow, color: Colors.white),
//           title: const Text("Play", style: TextStyle(color: Colors.white)),
//           onTap: () {
//             // Play the track logic here
//           },
//         ),
//         ListTile(
//           leading: const Icon(Icons.favorite_border, color: Colors.white),
//           title: const Text("Add to Favorites",
//               style: TextStyle(color: Colors.white)),
//           onTap: () {
//             // Add to favorites logic here
//           },
//         ),
//         ListTile(
//           leading: const Icon(Icons.share, color: Colors.white),
//           title: const Text("Share", style: TextStyle(color: Colors.white)),
//           onTap: () {
//             // Share track logic here
//           },
//         ),
//       ],
//     ),
//   );
// }
Widget _buildOptionsMenu(SongResponse track, BuildContext context) {
  final songProvider = Provider.of<SongProvider>(context, listen: false);
  final songApi = SongApi();

  return Container(
    decoration: const BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Track details at the top
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'http://localhost:8080/api/files/download/image/${track.albumImage}',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      track.artistName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white24, thickness: 1),

        // Options list
        Consumer<SongProvider>(
          builder: (context, songProvider, child) {
            songProvider.isLiked(track.id);

            return Column(
              children: [
                // Like/Unlike Song
                ListTile(
                  leading: Icon(
                    songProvider.isLiked(track.id) // Check if the song is liked
                        ? Icons.favorite // If liked, show the filled heart icon
                        : Icons
                            .favorite_border, // If not liked, show the border heart icon
                    color: Colors.white,
                  ),
                  title: Text(
                    songProvider.isLiked(
                            track.id) // Change title based on like status
                        ? "Remove from Liked Songs"
                        : "Add to Liked Songs",
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    // Fetch liked songs first to ensure the local list is up-to-date
                    await songProvider.fetchLikedSongs(context);

                    // Toggle the like status for the current song
                    await songProvider.toggleLikeStatus(context, track.id);

                    // Close the modal
                    Navigator.pop(context);
                  },
                ),
                // Add to Playlist
                ListTile(
                  leading: const Icon(Icons.playlist_add, color: Colors.white),
                  title: const Text("Add to Playlist",
                      style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    await songProvider.addToPlaylist(context, track);
                    Navigator.pop(context);
                  },
                ),
                // Hide Song
                const ListTile(
                  leading:
                      Icon(Icons.remove_circle_outline, color: Colors.white),
                  title:
                      Text("Hide Song", style: TextStyle(color: Colors.white)),
                  // onTap: () async {
                  //   await songProvider.hideSong(track.id);
                  //   Navigator.pop(context);
                  // },
                ),
                // Share
                ListTile(
                  leading: const Icon(Icons.share, color: Colors.white),
                  title: const Text("Share",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    // Share song logic
                  },
                ),
                // Additional actions here...
              ],
            );
          },
        ),
      ],
    ),
  );
}
