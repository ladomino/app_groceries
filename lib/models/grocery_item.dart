import 'package:app_groceries/data/categories.dart';
import 'package:app_groceries/models/category.dart';
import 'package:uuid/uuid.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;

  GroceryItem({
    required this.name,
    required this.quantity,
    required this.category,
  }) : id = Uuid().v4();

}

// Hardcoded grocery items
final List<GroceryItem> groceryItems = [
  GroceryItem(
    name: 'Milk',
    quantity: 1,
    category: categories[Categories.dairy]!,
  ),
  GroceryItem(
    name: 'Bananas',
    quantity: 5,
    category: categories[Categories.fruit]!,
  ),
  GroceryItem(
    name: 'Beef Steak',
    quantity: 1,
    category: categories[Categories.meat]!,
  ),
  GroceryItem(
    name: 'Bread',
    quantity: 2,
    category: categories[Categories.carbs]!,
  ),
  GroceryItem(
    name: 'Broccoli',
    quantity: 3,
    category: categories[Categories.vegetables]!,
  ),
];