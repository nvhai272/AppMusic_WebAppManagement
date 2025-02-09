import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/song_provider.dart';

/// Reusable ArtistDetails Widget
class GenreDetails extends StatelessWidget {
  final String genreName;
  // final String monthlyListeners;

  const GenreDetails({
    Key? key,
    required this.genreName,
    // required this.monthlyListeners,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          genreName,
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
    final songProvider = Provider.of<SongProvider>(context, listen: false);
 if (!isEnabled) {
      return Container(); // Hide the buttons when no songs are available
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Gọi hành động shuffle
            songProvider.shuffleAndPlay();  // Giả sử bạn đã định nghĩa hàm shuffleAndPlay trong SongProvider
          },
          icon: const Icon(Icons.shuffle, color: Colors.white),
          label: const Text('Shuffle', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Gọi hành động play
            songProvider.play(); // Phát bài hát
          },
          icon: const Icon(Icons.play_circle, color: Colors.white),
          label: const Text('Play', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
