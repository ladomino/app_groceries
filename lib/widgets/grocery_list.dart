import 'dart:convert';

import 'package:app_groceries/data/categories.dart';
import 'package:app_groceries/models/grocery_item.dart';
import 'package:app_groceries/widgets/new_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    // final url = Uri.https(
    //     'flutter-prep-default-rtdb.firebaseio.com', 'shopping-list.json');
    // final response = await http.get(url);

    // if (response.statusCode >= 400) {
    //   setState(() {
    //     _error = 'Failed to fetch data. Please try again later.';
    //   });
    // }

    // final Map<String, dynamic> listData = json.decode(response.body);

    // final List<GroceryItem> loadedItems = [];

    // for (final item in listData.entries) {
    //   final category = categories.entries
    //       .firstWhere(
    //           (catItem) => catItem.value.title == item.value['category'])
    //       .value;
    //   loadedItems.add(
    //     GroceryItem(
    //       id: item.key,
    //       name: item.value['name'],
    //       quantity: item.value['quantity'],
    //       category: category,
    //     ),
    //   );
    // }
    setState(() {
      //_groceryItems = loadedItems;
      _groceryItems = List.from(groceryItems);
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));

    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  void _removeItem(GroceryItem item) async {
    //final scaffoldMessenger = ScaffoldMessenger.of(context);

    final index = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });

    // final url = Uri.https(
    //   'fltter-prep-default-rtdb.firebaseio.com',
    //   'shopping-list/${item.id}.json',
    // );

    // final response = await http.delete(url);

    // if (response.statusCode >= 400) {
    //   // Optional: Show error message
    //   setState(() {
    //     _groceryItems.insert(index, item);
    //   });

    //   scaffoldMessenger.showSnackBar(
    //     SnackBar(
    //       content: Text('Failed to delete item. Please try again later.'),
    //       duration: Duration(seconds: 2),
    //     ),
    //   );
    // }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _groceryItems.insert(index, item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      // content = ListView.builder(
      //   itemCount: _groceryItems.length,
      //   itemBuilder:
      //       (ctx, index) => Dismissible(
      //         onDismissed: (direction) {
      //           _removeItem(_groceryItems[index]);
      //         },
      //         key: ValueKey(_groceryItems[index].id),
      //         child: ListTile(
      //           title: Text(_groceryItems[index].name),
      //           leading: Container(
      //             width: 24,
      //             height: 24,
      //             color: _groceryItems[index].category.color,
      //           ),
      //           trailing: Text(_groceryItems[index].quantity.toString()),
      //         ),
      //       ),
      // );
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Slidable(
          key: ValueKey(_groceryItems[index].id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.3, // width of the remove action pane
            children: [
              SlidableAction(
                onPressed: (context) {
                  _removeItem(_groceryItems[index]);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Remove',
              ),
            ],
          ),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
