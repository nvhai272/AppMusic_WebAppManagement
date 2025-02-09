import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '3.dart';


class NewsCarousel extends StatelessWidget {
  final List<Map<String, String>> newsData;

  const NewsCarousel({Key? key, required this.newsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: newsData.length,
      itemBuilder: (context, index, realIndex) {
        final news = newsData[index];
        return GestureDetector(
          onTap: () {
            // Navigate to NewsPage on click
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsPage(
                  title: news['title']!,
                  date: news['date']!,
                  image: news['image']!,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              // News Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  news['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              // News Title
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    news['title']!,
                    style: const TextStyle(
                      color: Colors.white,
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
  }
}
