import 'package:flutter/material.dart';
import 'shopping_bag.dart';
import 'menu_data.dart'; // Import the menu data from menu_data.dart

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> shoppingBag = [];  // List to hold items added to the shopping bag

  // Method to navigate to the shopping bag page
  void _navigateToBag(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShoppingBagPage(
          shoppingBag: shoppingBag,  // Pass the shopping bag data
          onItemRemoved: (index) {
            setState(() {
              shoppingBag.removeAt(index);  // Update shopping bag when an item is removed
            });
          },
          onOrderCompleted: (order) {
            // Handle order completion if needed
          },
        ),
      ),
    );
  }

  // Method to show a dialog with item details (name, description, price, quantity selector)
  void _showItemDetailsDialog(BuildContext context, Map<String, dynamic> item) {
    int quantity = 1;  // Default quantity is 1

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            // Using StatefulBuilder to allow rebuilding the dialog when quantity is updated
            return AlertDialog(
              title: Text(item['name']),  // Display the item name
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(item['image'],
                      width: 100, height: 100, fit: BoxFit.cover),  // Display item image
                  const SizedBox(height: 10),  // Space between image and description
                  Text(item['description']),  // Display item description
                  const SizedBox(height: 10),  // Space between description and price
                  Text('Price: \RM${item['price']}'),  // Display price
                  const SizedBox(height: 10),  // Space between price and quantity section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,  // Center the row
                    children: [
                      const Text('Quantity:'),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantity > 1
                            ? () {
                                setState(() {
                                  quantity--;  // Decrease quantity
                                });
                              }
                            : null,  // Disable button if quantity is 1
                      ),
                      Text(quantity.toString()),  // Display the current quantity
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;  // Increase quantity
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),  // Close the dialog
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Add the item to the shopping bag with the selected quantity
                      shoppingBag.add({
                        ...item,
                        'quantity': quantity,
                      });
                    });
                    Navigator.pop(context);  // Close the dialog after adding to bag
                  },
                  child: const Text('Add to Bag'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),  // Title of the page
      body: ListView.builder(
        itemCount: menuSections.length,  // Number of menu sections
        itemBuilder: (context, sectionIndex) {
          final section = menuSections[sectionIndex];
          final sectionTitle = section['section'] as String;  // Section title (e.g., "Breakfast Specials")
          final items = section['items'] as List<Map<String, dynamic>>;  // List of items in the section

          return ExpansionTile(
            title: Text(sectionTitle),  // Display the section title
            children: items.map((item) {
              final itemName = item['name'] as String;  // Item name
              final itemPrice = item['price'] as double;  // Item price
              final itemImage = item['image'] as String;  // Item image

              return ListTile(
                leading: Image.asset(itemImage, width: 50, height: 50, fit: BoxFit.cover),  // Item image thumbnail
                title: Text(itemName),  // Item name
                subtitle: Text('\RM${itemPrice.toStringAsFixed(2)}'),  // Item price (formatted to 2 decimal places)
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Show the item details dialog when "Add" button is pressed
                    _showItemDetailsDialog(context, item);
                  },
                ),
              );
            }).toList(),  // Map each item in the section to a ListTile
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          icon: const Icon(Icons.shopping_bag),  // Icon for the shopping bag button
          onPressed: () => _navigateToBag(context),  // Navigate to the shopping bag page
        ),
      ),
    );
  }
}
