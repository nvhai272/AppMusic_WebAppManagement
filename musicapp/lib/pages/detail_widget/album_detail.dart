import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/album_provider.dart';
import '../../providers/song_provider.dart';

/// Reusable ArtistDetails Widget
class AlbumDetailPage extends StatelessWidget {
  final String albumTitle;
  final String artistName;

  const AlbumDetailPage({
    Key? key,
    required this.albumTitle,
    required this.artistName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          albumTitle,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$artistName',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Reusable ActionButtons Widget
class ActionButtons extends StatelessWidget {
  final VoidCallback? onPlayTap;
  final VoidCallback? onShuffleTap;
  final int albumId;
  final bool isLiked;
  final bool isEnabled; // This is passed to change the icon color

  const ActionButtons({
    Key? key,
    required this.onPlayTap,
    required this.onShuffleTap,
    required this.albumId,
    required this.isLiked,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isEnabled) {
      return Container(); // Hide the buttons when no songs are available
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            final albumProvider =
                Provider.of<AlbumProvider>(context, listen: false);
            albumProvider.toggleLikeStatus(
                context, albumId); // Toggle like status
          },
          icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
              size: 30 // Change icon color
              ),
        ),
        IconButton(
          onPressed: () {
            onShuffleTap!(); // Shuffle functionality
          },
          icon: const Icon(Icons.shuffle, color: Colors.white, size: 30),
        ),
        IconButton(
          onPressed: () {
            onPlayTap!(); // Play functionality
          },
          icon: const Icon(
            Icons.play_circle,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }
}
