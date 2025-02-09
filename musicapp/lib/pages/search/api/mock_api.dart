import '../model/item.dart';

class MockApi {
  Future<List<Item>> fetchItems() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      Item(id: '1', name: 'Apple'),
      Item(id: '2', name: 'Banana'),
      Item(id: '3', name: 'Cherry'),
      Item(id: '4', name: 'Date'),
      Item(id: '5', name: 'Elderberry'),
    ];
  }
Future<List<Item>> searchItems(String query) async {
    final mockResponse = [
      {'id': 1, 'name': 'Apple'},
      {'id': 2, 'name': 'Banana'},
      {'id': 3, 'name': 'Elderberry'},
    ];
    await Future.delayed(Duration(seconds: 1));
    try {
      // Filter the mock data for a matching item by keyword
      final filteredItems = mockResponse.where(
        (item) => (item['name'] as String)
            .toLowerCase()
            .contains(query.toLowerCase()),
      ).toList();

      // Convert the filtered result to a list of Item objects
      return filteredItems.map((item) {
        return Item(id: item['id'].toString(), name: item['name'].toString());
      }).toList();
    } catch (error) {
      print("Error searching for item: $error");
      return []; // Return an empty list if an error occurs
    }
  }
}
