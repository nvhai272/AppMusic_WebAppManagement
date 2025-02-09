import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/song_provider.dart';

/// Reusable ArtistDetails Widget
class PlaylistDetail extends StatelessWidget {
  final String playlistName;
  // final String monthlyListeners;

  const PlaylistDetail({
    Key? key,
    required this.playlistName,
    // required this.monthlyListeners,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlistName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        // Text(
        //   '$monthlyListeners người nghe hàng tháng',
        //   style: const TextStyle(
        //     fontSize: 16,
        //     color: Colors.white70,
        //   ),
        // ),
        const SizedBox(height: 16),
  
      ],
    );
  }
}

/// Reusable ActionButtons Widget
class ActionButtons extends StatelessWidget {
  final VoidCallback? onPlayTap;
  final VoidCallback? onShuffleTap;
  final bool isEnabled;

  const ActionButtons({
    Key? key,
    required this.onPlayTap,
    required this.onShuffleTap,
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
        ElevatedButton.icon(
          onPressed: isEnabled ? onShuffleTap : null,
          icon: const Icon(Icons.shuffle, color: Colors.white),
          label: const Text('Shuffle', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? Colors.grey[800] : Colors.grey[500],
            disabledBackgroundColor: Colors.grey[500],
          ),
        ),
        ElevatedButton.icon(
          onPressed: isEnabled ? onPlayTap : null,
          icon: const Icon(Icons.play_circle, color: Colors.white),
          label: const Text('Play', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? Colors.red : Colors.grey[500],
            disabledBackgroundColor: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}
