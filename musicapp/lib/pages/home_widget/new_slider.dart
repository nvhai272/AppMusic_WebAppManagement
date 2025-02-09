import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../models/news.dart';

import '../../services/api/news_api.dart';
import '../news_page.dart';

class NewsCarousel extends StatelessWidget {
  const NewsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsApi newsApi = NewsApi();

    return FutureBuilder<List<News>>(
      future: newsApi.fetchNews(context), // Fetch the news
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final newsList = snapshot.data!; // Get the news data
          print(newsList);
          return CarouselSlider.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index, realIndex) {
              final news = newsList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsPage(id: news.id),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'http://localhost:8080/api/files/download/image/${news.image}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        // color: Colors.black.withOpacity(0.5),
                        child: Text(
                          news.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
            ),
          );
        } else {
          return const Center(child: Text('No news available.'));
        }
      },
    );
  }
}
