import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/genre_provider.dart';

class CustomButton extends StatelessWidget {
  final int id; // Pass the id instead of label
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.id,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final genreProvider = Provider.of<GenreProvider>(context);
    return FutureBuilder(
      future: genreProvider.getItemById(id, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child:
                const CircularProgressIndicator(), // Loading indicator while fetching
          );
        } else if (snapshot.hasError) {
          return ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Error'), // Show error if fetching fails
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          // Once data is fetched, display the title
          return ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              snapshot.data!.title, // Display the title dynamically
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('No Title'), // Fallback if no data found
          );
        }
      },
    );
  }
}
