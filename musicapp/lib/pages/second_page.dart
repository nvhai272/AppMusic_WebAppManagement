import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SecondPage(),
  ));
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container( 
                width: 600, // Set the width
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("/images/musicix2.png"),
                    fit: BoxFit.cover, // Ensure this path is correct
                  ),
                ),
              ),
            ),
            // const Text(
            //   "MUSICIX",
            //   style: TextStyle(
            //     fontSize: 40,
            //     fontWeight: FontWeight.bold,
            //     fontStyle: FontStyle.italic,
            //     color: Color.fromARGB(255, 0, 0, 0),
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            const Text(
              "LISTEN MUSIC FREE ON MUSICIX",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            // Login Button
            ElevatedButton(
              onPressed: () {
                // Add your login navigation logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 45.0),
              ),
              child: const Text(
                "Đăng Nhập",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Add your register navigation logic here
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 50.0),
              ),
              child: const Text(
                "Đăng Kí",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
