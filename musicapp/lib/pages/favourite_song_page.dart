import 'package:flutter/material.dart';
import 'package:musicapp/dto/request/like_request.dart';
import 'package:musicapp/pages/song_page.dart';

import 'package:provider/provider.dart';
import '../providers/fav_provider.dart';
import '../providers/song_provider.dart';

class FavouritePage extends StatelessWidget {
  final int userId;

  const FavouritePage(
      {super.key, required this.userId}); // Static user ID for the example

  void goToSong(BuildContext context, int songIndex) {
    final playlistProvider = Provider.of<SongProvider>(context, listen: false);

    if (playlistProvider.songs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No songs available for playback.")),
      );
      return;
    }

    playlistProvider.currentSongIndex = songIndex;
    playlistProvider.play(isCalledFromUI: false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongPage()),
    );
  }

  Widget _getFavIcon(
      UserFavoritesProvider favProvider, SongLikeRequest requestData) {
    return Icon(
      favProvider.isFavouriteSong(requestData)
          ? Icons.favorite
          : Icons.favorite_border,
      color:
          favProvider.isFavouriteSong(requestData) ? Colors.red : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch providers for UserFavorites and Song
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SongProvider>(context, listen: false)
          .fetchLikedSongs(context);
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Favorite Songs',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 62, 62, 62),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        body: Consumer<SongProvider>(builder: (context, songProvider, child) {
          return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 62, 62, 62),
                    Color.fromARGB(255, 0, 0, 0)
                  ],
                ),
              ),
              child: songProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : songProvider.songs.isEmpty
                      ? Center(
                          child: Text(
                          "No favorite songs found.",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ))
                      : _renderListSong(context, songProvider));
        }));
  }

  Widget _renderListSong(BuildContext context, SongProvider songProvider) {
    return ListView.builder(
      itemCount: songProvider.songs.length,
      itemBuilder: (context, index) {
        final song = songProvider.songs[index];
        SongLikeRequest requestData =
            SongLikeRequest(userId: userId, itemId: song.id);

        return ListTile(
            onTap: () => goToSong(context, index ),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 2),
                SizedBox(width: 5),
                CircleAvatar(
                    backgroundImage: NetworkImage(
                        'http://localhost:8080/api/files/download/image/${song.albumImage}'))
              ],
            ),
            title: Text(
              song.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'San Francisco'),
            ),
            subtitle: Text(
              '${song.artistName}   ${song.albumTitle}',
              style:
                  TextStyle(color: Colors.white, fontFamily: 'San Francisco'),
            ),
            trailing: Consumer<UserFavoritesProvider>(
              builder: (context, favProvider, child) {
                // If the song's favorite status is not cached, fetch it
                if (!favProvider.isFavouriteSong(requestData)) {
                  favProvider.fetchFavoriteSongStatus(
                      requestData, context); // Fetch data asynchronously once
                }

                return CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: _getFavIcon(favProvider, requestData),
                    onPressed: () async {
                      // Handle toggling favorite status
                      if (favProvider.isFavouriteSong(requestData)) {
                        // Remove song from favorites
                        await favProvider.removeUserFavoriteSong(
                            requestData, context);
                      } else {
                        // Add song to favorites
                        await favProvider.addUserFavoriteSong(
                            requestData, context);
                      }

                      // Fetch the updated favorite status and notify listeners
                      await favProvider.fetchFavoriteSongStatus(
                          requestData, context);
                    },
                  ),
                );
              },
            ));
      },
    );
  }
}
