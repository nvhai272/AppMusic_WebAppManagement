import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/item_provider.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemProvider>(context, listen: false).fetchItems();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Items'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(context),
            SizedBox(height: 16),
            // Using Consumer to listen for changes in items
            Consumer<ItemProvider>(
              builder: (context, itemProvider, child) {
                if (itemProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (itemProvider.items.isEmpty) {
                  return Center(child: Text('No items found.'));
                } else {
                  return _buildSearchResults(context, itemProvider);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build the search field
  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Search for an item',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.search),
      ),
      onChanged: (query) {
        if (query.isNotEmpty) {
          // Trigger the search when the user types in the search field
          Provider.of<ItemProvider>(context, listen: false).searchItems(query);
        } else {
          // Clear the list when the query is empty
          Provider.of<ItemProvider>(context, listen: false).clearItems();
        }
      },
    );
  }

  // Build the list of search results
  Widget _buildSearchResults(BuildContext context, ItemProvider itemProvider) {
    return Expanded(
      child: ListView.builder(
        itemCount: itemProvider.items.length,
        itemBuilder: (context, index) {
          final item = itemProvider.items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('ID: ${item.id}'),
            onTap: () {
              // Handle item tap
              print('Tapped on item: ${item.name}');
            },
          );
        },
      ),
    );
  }
}
