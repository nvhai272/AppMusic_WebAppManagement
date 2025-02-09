import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:musicapp/services/api/api.dart';
import 'package:musicapp/services/api/urlConsts.dart';

import '../../models/genre.dart';

class GenreApi extends Api{
  
  Future<List<Genre>> fetchItems( BuildContext context) async {
    var response = await get(UrlConsts.GENRE,context);

    // Check if the response is successful
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<Genre?> fetchItemById(int id,BuildContext context) async {
     var response = await get('${UrlConsts.GENRE}/$id', context);


    // Check if the response is successful
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Genre.fromJson(data);
    } else {
      throw Exception('Failed to load genre with id $id');
    }
  }
  

  // Mock response data
  //   final mockResponse = [
  //     {"id": 1, "title": "Rnb", "image": "image1.png", "color": "brown"},
  //     {"id": 2, "title": "Chill", "image": "image2.png", "color": "blue"},
  //     {"id": 3, "title": "Love", "image": "image3.png", "color": "red"},
  //     {"id": 4, "title": "Rock", "image": "image4.png", "color": "green"},
  //     {"id": 5, "title": "Pop", "image": "image5.png", "color": "pink"},
  //     {"id": 6, "title": "Alternative", "image": "image6.png", "color": "blue"},
  //     {"id": 7, "title": "Anime", "image": "image7.png", "color": "blue"},
  //     {"id": 8, "title": "Blues", "image": "image8.png", "color": "blue"},
  //     {
  //       "id": 9,
  //       "title": "Children's Music",
  //       "image": "image9.png",
  //       "color": "grey"
  //     },
  //     {"id": 10, "title": "Classical", "image": "image10.png", "color": "blue"},
  //     {"id": 11, "title": "Comedy", "image": "image11.png", "color": "grey"},
  //     {"id": 12, "title": "Country", "image": "image12.png", "color": "blue"},
  //     {"id": 13, "title": "Dance", "image": "image13.png", "color": "grey"},
  //     {"id": 14, "title": "Disney", "image": "image14.png", "color": "blue"},
  //     {
  //       "id": 15,
  //       "title": "Easy Listening",
  //       "image": "image15.png",
  //       "color": "grey"
  //     },
  //     {
  //       "id": 16,
  //       "title": "Electronic",
  //       "image": "image16.png",
  //       "color": "blue"
  //     },
  //     {"id": 17, "title": "Enka", "image": "image17.png", "color": "grey"},
  //     {
  //       "id": 18,
  //       "title": "French Pop",
  //       "image": "image18.png",
  //       "color": "blue"
  //     },
  //     {
  //       "id": 19,
  //       "title": "Fitness & Workout",
  //       "image": "image19.png",
  //       "color": "blue"
  //     },
  //     {
  //       "id": 20,
  //       "title": "Hip-Hop/Rap",
  //       "image": "image20.png",
  //       "color": "blue"
  //     },
  //     {"id": 21, "title": "Indie Pop", "image": "image21.png", "color": "blue"},
  //     {
  //       "id": 22,
  //       "title": "Instrumental",
  //       "image": "image22.png",
  //       "color": "blue"
  //     },
  //     {"id": 23, "title": "J-Pop", "image": "image23.png", "color": "blue"},
  //     {"id": 24, "title": "Jazz", "image": "image24.png", "color": "blue"},
  //     {"id": 25, "title": "Rock", "image": "image25.png", "color": "blue"},
  //     {"id": 26, "title": "R&B/Soul", "image": "image26.png", "color": "blue"},
  //     {"id": 27, "title": "Reggae", "image": "image27.png", "color": "blue"},
  //     {
  //       "id": 28,
  //       "title": "Soundtrack",
  //       "image": "image28.png",
  //       "color": "blue"
  //     },
  //     {
  //       "id": 29,
  //       "title": "Spoken Word",
  //       "image": "image29.png",
  //       "color": "blue"
  //     }
  //   ];

  //   await Future.delayed(Duration(seconds: 1)); // Simulate network delay
  //   return mockResponse.map((json) => Genre.fromJson(json)).toList();
  // }

  // Future<Genre?> fetchItemsById(int id) async {
  //   final mockResponse = [
  //     {"id": 1, "title": "Rnb", "image": "image1.png", "color": "brown"},
  //     {"id": 2, "title": "Chill", "image": "image2.png", "color": "blue"},
  //     {"id": 3, "title": "Love", "image": "image3.png", "color": "red"},
  //     {"id": 4, "title": "Rock", "image": "image4.png", "color": "green"},
  //     {"id": 5, "title": "Pop", "image": "image5.png", "color": "pink"},
  //   ];

  //   await Future.delayed(Duration(seconds: 1)); // Giả lập độ trễ mạng

  //   try {
  //     final item = mockResponse.firstWhere(
  //       (element) => element['id'] == id,
  //     );

  //     if (item != null) {
  //       return Genre.fromJson(item);
  //     } else {
  //       throw Exception('Item with id $id not found');
  //     }
  //   } catch (e) {
  //     print('Error fetching item by id: $e');
  //     return null;
  //   }
  // }

  // Future<Genre> addItem(Genre item) async {
  //   // Mock adding item
  //   await Future.delayed(Duration(seconds: 1)); // Simulate network delay
  //   return item;
  // }

  // Future<void> deleteItem(int id) async {
  //   // Mock deleting item
  //   await Future.delayed(Duration(seconds: 1)); // Simulate network delay
  // }
}
