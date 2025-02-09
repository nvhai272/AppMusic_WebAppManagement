import 'package:flutter/material.dart';
import 'package:musicapp/dto/response/playlist_response.dart';
import 'package:musicapp/pages/detail_widget/playlist_detail.dart';
import 'package:provider/provider.dart';

import '../providers/song_provider.dart';

import 'general_widget/audio_card.dart';
// import 'general_widget/audio_card2.dart';
import 'general_widget/track_list.dart';

class PlaylistSongPage extends StatelessWidget {
  final PlaylistResponse playlist;

  const PlaylistSongPage({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      songProvider.fetchSongsByPlaylist(playlist.id, context);
    });
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   backgroundColor: Colors.black,
      //   elevation: 0,
      // ),

      body: Consumer<SongProvider>(
        builder: (context, songProvider, child) {
          return songProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh của thể loại (Genre Image)
                    Stack(
                      children: [
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'http://localhost:8080/api/files/download/image/${playlist.songQty}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Gradient overlay
                        Container(
                          height: 300,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40, // Điều chỉnh khoảng cách từ trên xuống
                          left: 16,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                            iconSize: 28,
                            tooltip: 'Back',
                          ),
                        ),
                        // Chi tiết thể loại
                        Positioned(
                          bottom: 60,
                          left: 16,
                          child: PlaylistDetail(
                            playlistName: playlist.title,
                            // monthlyListeners: genre.monthlyListeners,
                          ),
                        ),
                        // Nút Play và Shuffle
                        Positioned(
                          bottom: 10,
                          left: 16,
                          right: 16,
                          child: ActionButtons(
                            onPlayTap: songProvider.songs.isNotEmpty
                                ? () => songProvider.play()
                                : null, // Wrap in a synchronous callback
                            onShuffleTap: songProvider.songs.isNotEmpty
                                ? () => songProvider.shuffleAndPlay()
                                : null, // Wrap in a synchronous callback
                            isEnabled: songProvider.songs.isNotEmpty,
                          ),
                        ),
                      ],
                    ),

                    // Danh sách bài hát
                    Expanded(
                      child: Stack(
                        children: [
                          // Popular tracks list
                          Container(
                            color: Colors.black,
                            child:
                                PopularTracksList(tracks: songProvider.songs),
                          ),
                          // Conditionally display AudioCard on top
                          if (songProvider.shouldShow())
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 560, // Adjust to place above footer
                              child: AudioCard(),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
