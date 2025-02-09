import 'package:flutter/material.dart';
import '../services/api/news_api.dart';

class NewsPage extends StatelessWidget {
  final int id; // The ID of the selected news

  const NewsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final NewsApi newsApi = NewsApi();

    return Scaffold(
      appBar: AppBar(
        title: const Text("News Detail"),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: newsApi.fetchNewsById(id, context), // Fetch the news details
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (snapshot.hasData) {
            final news = snapshot.data;

            if (news == null) {
              return const Center(child: Text('No news found.'));
            }

            return SingleChildScrollView(
              child: Container(
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // News Image
                    Image.network(
                      'http://localhost:8080/api/files/download/image/${news.image}',
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // News Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        news.title,
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // News Date
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        news.createdAt,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // News Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        news.content ?? 'No content available.',
                        style:
                            const TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No news available.'));
          }
        },
      ),
    );
  }
}
