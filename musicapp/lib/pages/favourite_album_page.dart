import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Correct import path
import 'package:musicapp/providers/album_provider.dart';

import 'home_widget/album_page.dart';

class FavouriteAlbumPage extends StatelessWidget {
  const FavouriteAlbumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlbumProvider>(context, listen: false)
          .fetchLikedAlbums(context);
    });
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 62, 62, 62),
              Color.fromARGB(255, 0, 0, 0)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Consumer<AlbumProvider>(
          builder: (context, albumProvider, child) {
            if (albumProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final favoriteAlbums = albumProvider.favoriteAlbums;

            if (favoriteAlbums.isEmpty) {
              return const Center(
                child: Text(
                  "No favorite albums found.",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteAlbums.length,
              itemBuilder: (context, index) {
                final album = favoriteAlbums[index];
                return _buildAlbumTile(context, albumProvider, album);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAlbumTile(
      BuildContext context, AlbumProvider albumProvider, dynamic album) {
    final isLiked = albumProvider.isLiked(album.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(
          'http://localhost:8080/api/files/download/image/${album.image}',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
          },
        ),
        title: Text(album.title, style: const TextStyle(fontSize: 16)),
        subtitle: Text(album.artistName ?? "Unknown Artist"),
        trailing: IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            albumProvider.toggleLikeStatus(context, album.id).then((_) {
              // Trigger UI update after like/unlike
            });
          },
        ),
        onTap: () {
          // Navigate to the AlbumPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlbumPage(album: album),
            ),
          );
        },
      ),
    );
  }
}
