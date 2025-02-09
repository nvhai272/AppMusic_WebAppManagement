import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/genre.dart';
import '../../providers/genre_provider.dart';
import '../genre_page.dart';
import 'button_custom.dart';
import 'genre_widget.dart';

class GenreButton extends StatelessWidget {
  const GenreButton({super.key});

  @override
  Widget build(BuildContext context) {
     final genreProvider = Provider.of<GenreProvider>(context, listen: false);
  
    return FutureBuilder<List<Genre>>(
       future: genreProvider.loadItems(context),// Tải dữ liệu từ Provider
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final genres = snapshot.data!;
          final topGenres = genres.take(4).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...topGenres.map(
                  (genre) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomButton(
                      id: genre.id,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GenrePage(genre: genre),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GenreList(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'More...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('No data found.'));
      },
    );
  }
}
