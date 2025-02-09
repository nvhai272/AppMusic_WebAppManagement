import 'package:flutter/material.dart';
import 'package:musicapp/dto/response/album_response.dart';
import 'package:musicapp/pages/detail_widget/album_detail.dart';
import 'package:musicapp/pages/general_widget/album_track_list.dart';

import 'package:provider/provider.dart';

import '../../providers/album_provider.dart';
import '../../providers/song_provider.dart';
import '../general_widget/audio_card.dart';
import '../general_widget/track_list.dart';

// import 'general_widget/audio_card2.dart';

class AlbumPage extends StatelessWidget {
  final AlbumResponse album;

  const AlbumPage({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      songProvider.fetchSongsByAlbum(album.id, context);
      Provider.of<AlbumProvider>(context, listen: false)
          .fetchLikedAlbums(context);
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
                    Stack(
                      children: [
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'http://localhost:8080/api/files/download/image/${album.image}'),
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
                          child: AlbumDetailPage(
                            albumTitle: album.title,
                            artistName: album.artistName!,
                          ),
                        ),
                        // Nút Play và Shuffle
                        Positioned(
                          bottom: 10,
                          left: 16,
                          right: 16,
                          child: Consumer<AlbumProvider>(
                            builder: (context, albumProvider, child) {
                              return ActionButtons(
                                albumId: album.id,
                                onPlayTap: songProvider.songs.isNotEmpty
                                    ? () => songProvider.play()
                                    : null, // Wrap in a synchronous callback
                                onShuffleTap: songProvider.songs.isNotEmpty
                                    ? () => songProvider.shuffleAndPlay()
                                    : null, // Wrap in a synchronous callback
                                isEnabled: songProvider.songs.isNotEmpty,
                                isLiked: albumProvider.isLiked(album.id),
                              );
                            },
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
                            child: AlbumTrackList(tracks: songProvider.songs),
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
