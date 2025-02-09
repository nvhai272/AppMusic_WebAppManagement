import 'package:flutter/material.dart';
import 'package:musicapp/models/genre.dart';
import 'package:musicapp/pages/general_widget/background_gradiant.dart';
import 'package:musicapp/pages/home_widget/genre_card.dart';
import 'package:musicapp/providers/genre_provider.dart';

import 'package:provider/provider.dart';

import '../genre_page.dart';

class GenreList extends StatelessWidget {
  const GenreList({
    super.key,
  });

  // Helper method for error state UI
  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Text(
        'Error: $error',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // Helper method for empty state UI
  Widget _buildEmptyWidget() {
    return const Center(
      child: Text(
        'No genres found',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Helper method for loading state UI
  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    final genreProvider = Provider.of<GenreProvider>(context, listen: false);
    return GradientBackground(
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Set transparent to let gradient show
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Select Genres',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
          ),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back
            },
          ),
          backgroundColor:
              Colors.transparent, // AppBar transparent to match gradient
        ),
        body: FutureBuilder<List<Genre>>(
          future: genreProvider.loadItems(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingWidget();
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error!);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyWidget();
            } else {
              final items = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: items.map((item) {
                    return GenreCard(
                      genre: item,
                      onTap: () {
                        Future.delayed(Duration.zero, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenrePage(genre: item),
                            ),
                          );
                          print('Genre ${item.title} clicked!');
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
