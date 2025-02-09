import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/dto/request/like_request.dart';

import 'package:provider/provider.dart';

import '../providers/fav_provider.dart';

import '../providers/user_provider.dart';

class CommonAppBar extends StatelessWidget {
  final int? albumId;
  final String label1;
  final String label2;
  final String appBarImg;
  final bool isUserFav;

  const CommonAppBar({
    required this.label1,
    required this.label2,
    required this.appBarImg,
    this.albumId,
    required this.isUserFav,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return AppBar(
      flexibleSpace: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(appBarImg),
                  fit: BoxFit.cover,
                  opacity: 0.7,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16, bottom: 50),
              child: Row(
                children: [
                  Text(
                    "$label1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                  isUserFav == false
                      ? Consumer<UserFavoritesProvider>(
                    builder: (context, favProvider, child) {
                      final currentUser = userProvider.currentUser;
                      if (albumId != null) {
                        SongLikeRequest requestData = SongLikeRequest(
                          userId: currentUser!.id!,
                          itemId: albumId!,
                        );

                        // Fetch the album's favorite status if not cached
                        if (!favProvider.isFavouriteAlbum(requestData)) {
                          favProvider.fetchFavoriteAlbumStatus(
                            requestData,
                            context,
                          );
                        }

                        return CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              favProvider.isFavouriteAlbum(requestData)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favProvider.isFavouriteAlbum(requestData)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () async {
                              // Handle toggling favorite status
                              if (favProvider.isFavouriteAlbum(requestData)) {
                                // Remove album from favorites
                                await favProvider.removeUserFavoriteAlbum(requestData, context);
                              } else {
                                // Add album to favorites
                                await favProvider.addUserFavoriteAlbum(requestData, context);
                              }

                              // After the operation, fetch the updated favorite status again
                              favProvider.fetchFavoriteAlbumStatus(requestData, context);

                              // Notify listeners to trigger a UI update
                            
                            },
                          ),
                        );
                      }

                      return SizedBox(width: 20); // Return an empty space if no albumId
                    },
                  )
                      : SizedBox(width: 20),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16, bottom: 10),
              child: isUserFav == true
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('assets/images/avatar.png'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '$label2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
                  : Text(
                '$label2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}