import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../dto/request/playlist_request.dart';
import '../providers/playlist_provider.dart';
import '../shared_preference/share_preference_service.dart';
import 'playlist_song_page.dart';

class PlaylistPage extends StatelessWidget {
  PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    // Fetch playlists initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playlistProvider.fetchPlaylists(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Library",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _showAddPlaylistDialog(context, playlistProvider);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromARGB(255, 219, 4, 76)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Consumer<PlaylistProvider>(
          builder: (context, playlistProvider, child) {
            final playlists = playlistProvider.playlists;

            if (playlists.isEmpty) {
              return const Center(child: Text('No playlists available.'));
            }

            return ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.white),
                  title: Text(
                    playlist.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Playlist • ${playlist.userName}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Track • ${playlist.songQty}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white70),
                        onPressed: () {
                          // _showEditPlaylistDialog(
                          //     context, playlistProvider, playlist);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white70),
                        onPressed: () {
                          _showDeleteDialog(
                              context, playlist.id, playlistProvider);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PlaylistSongPage(playlist: playlist)));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Future<bool> _showDeleteDialog(BuildContext context, int playlistId,
    PlaylistProvider playlistProvider) async {
  bool confirmDelete = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có thật sự muốn xóa playlist này?'),
        actions: [
          TextButton(
            onPressed: () {
              confirmDelete = false;
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await playlistProvider.deletePlaylist(
                  context, playlistProvider, playlistId);
              confirmDelete = true;
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
  return confirmDelete;
}

void _showAddPlaylistDialog(
    BuildContext context, PlaylistProvider playlistProvider) {
  final TextEditingController _playlistNameController = TextEditingController();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text(
          "Create New Playlist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _playlistNameController,
              decoration: const InputDecoration(
                labelText: "Playlist Name",
                hintText: "Enter playlist name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final playlistName = _playlistNameController.text.trim();
                  if (playlistName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Playlist name cannot be empty.")),
                    );
                    return;
                  }

                  try {
                    // Fetch the user ID from SharedPreferences
                    final userId = await _prefsService.getUserId();
                    if (userId == null) {
                      throw Exception("User ID is not available.");
                    }

                    // Prepare the playlist request
                    final playlistRequest = PlaylistRequest(
                      title: playlistName,
                      userId: userId,
                    );

                    // Add the playlist and update the list
                    await playlistProvider.addPlaylist(
                        context, playlistRequest);

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Playlist '$playlistName' created successfully!")),
                    );
                  } catch (e) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to create playlist: $e")),
                    );
                  }

                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text("Create"),
              ),
            ],
          ),
        ],
      );
    },
  );
}
