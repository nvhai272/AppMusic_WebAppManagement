import 'package:flutter/material.dart';
import 'package:musicapp/components/my_drawer.dart';
import 'package:musicapp/pages/v1/playlist_provider.dart';
import 'package:musicapp/models/song.dart';
import 'package:musicapp/pages/general_widget/audio_card.dart';
import 'package:musicapp/pages/v1/song_page2.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PlaylistProvider playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongPage2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("P L A Y L I S T"),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          // Playlist Section
          Expanded(
            child: Consumer<PlaylistProvider>(
              builder: (context, value, child) {
                List<Song> playlist = value.playlist;

                return ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final Song song = playlist[index];

                    return ListTile(
                      title: Text(song.songName),
                      subtitle: Text(song.artistName),
                      leading: Image.asset(song.albumArtImagePath),
                      onTap: () => goToSong(index),
                    );
                  },
                );
              },
            ),
          ),
          // Audio Card Section
          AudioCard(),
        ],
      ),
    );
  }
}
