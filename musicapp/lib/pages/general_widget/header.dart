import 'package:flutter/material.dart';
import 'package:musicapp/providers/user_provider.dart'; // Update the path if necessary
import 'package:provider/provider.dart';

class GeneralHeader extends StatelessWidget {
  const GeneralHeader({super.key});

  // Get greeting based on the time of day
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<UserProvider>(context, listen: false)
    //       .fetchUserData(context);
    // });
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        //  borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(20.0), // Rounded top corners
        //   bottomRight: Radius.circular(20.0),
        // ),
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(211, 250, 0, 0),
            Color.fromARGB(255, 62, 62, 62)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Check if the user is logged in and user data is available
          userProvider.fetchUserData(context);
          // final user = userProvider.currentUser!;
          if (!userProvider.isLoggedIn || userProvider.currentUser == null) {
            return const Center(
              child: Text(
                'Not logged in',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final user = userProvider.currentUser!;
          // Display the greeting and avatar
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting text
                Text(
                  "${getGreeting()}, ${user.username?.replaceAll('_', ' ')}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                // Spacing and avatar
                GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                     backgroundImage: (user.avatar?.isNotEmpty ?? false)
                          ? NetworkImage('http://localhost:8080/api/files/download/image/${user.avatar}')
                          : null,
                      child: (user.avatar?.isEmpty ?? true)
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    // backgroundImage: user.avatar != null &&
                    //         user.avatar!.isNotEmpty
                    //     ? (user.avatar!.startsWith('http')
                    //         ? NetworkImage(
                    //                 'http://localhost:8080/api/files/download/image/${user.avatar}')
                    //             as ImageProvider
                    //         : AssetImage('assets/images/6.jpg')
                    //             as ImageProvider)
                    //     : null,
                    radius: 20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
