import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Firstpage(),
  ));
}

class Firstpage extends StatelessWidget {
  const Firstpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/welcome.jpg"), // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Content overlay
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title text
            const Padding(
              padding: EdgeInsets.only(
                  top: 400.0), // Adjust padding for better positioning
              child: Center(
                child: Text(
                  "WE ARE CHILL GUYS",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
            // Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Define navigation logic or other actions here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 79, 78, 78)
                        .withOpacity(0.8), // Keep the opacity consistent
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Smooth button edges
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ), // Adjust button padding
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize
                        .min, // Keep the button as small as its content
                    children: [
                      Text(
                        "NEXT",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                          width: 5), // Add space between text and icon
                      Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.white, // Keep consistent icon color
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
