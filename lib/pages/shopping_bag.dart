import 'package:flutter/material.dart';
import 'payment_page.dart';

class ShoppingBagPage extends StatefulWidget {
  // This page receives the shopping bag data and callback functions for item removal and order completion.
  final List<Map<String, dynamic>> shoppingBag;
  final Function(int) onItemRemoved;
  final Function(Map<String, dynamic>) onOrderCompleted;

  // Constructor to initialize the shopping bag and functions.
  const ShoppingBagPage({
    required this.shoppingBag,
    required this.onItemRemoved,
    required this.onOrderCompleted,
    super.key,
  });

  @override
  _ShoppingBagPageState createState() => _ShoppingBagPageState();
}

class _ShoppingBagPageState extends State<ShoppingBagPage> {
  late List<Map<String, dynamic>> _shoppingBag;

  @override
  void initState() {
    super.initState();
    // Initializing the shopping bag with the data passed to this page.
    _shoppingBag = List.from(widget.shoppingBag);
  }

  // Method to refresh the shopping bag when items are added or removed
  void _refreshBag() {
    setState(() {
      _shoppingBag = List.from(widget.shoppingBag);
    });
  }

  // Method to update the quantity of an item in the shopping bag
  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        // Update the item quantity if it is greater than 0
        _shoppingBag[index]['quantity'] = newQuantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculating the total amount for the items in the shopping bag.
    double totalAmount = _shoppingBag.fold(0.0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Bag'),
        actions: [
          // Refresh button to reload the shopping bag data
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshBag,
          ),
        ],
      ),
      body: Column(
        children: [
          // Displaying the items in the shopping bag using a ListView.
          Expanded(
            child: ListView.builder(
              itemCount: _shoppingBag.length, // Number of items in the bag
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    _shoppingBag[index]
                        ['image']!, // Display the image of the item
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(_shoppingBag[index]['name']!), // Item name
                  subtitle: Text(
                      'RM${(_shoppingBag[index]['price'] * _shoppingBag[index]['quantity']).toStringAsFixed(2)} x ${_shoppingBag[index]['quantity']}'), // Item price and quantity
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Button to decrease item quantity
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          int currentQuantity = _shoppingBag[index]['quantity'];
                          if (currentQuantity > 1) {
                            // Decrease quantity if greater than 1
                            _updateQuantity(index, currentQuantity - 1);
                          }
                        },
                      ),
                      // Button to increase item quantity
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          int currentQuantity = _shoppingBag[index]['quantity'];
                          // Increase quantity
                          _updateQuantity(index, currentQuantity + 1);
                        },
                      ),
                      // Button to remove item from the bag
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          widget.onItemRemoved(
                              index); // Call callback to remove item
                          setState(() {
                            _shoppingBag
                                .removeAt(index); // Remove item from the list
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Display the total amount and proceed to payment button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: RM${totalAmount.toStringAsFixed(2)}', // Total cost of items in the bag
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_shoppingBag.isNotEmpty) {
                      // Navigate to payment page if there are items in the bag
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            totalAmount:
                                totalAmount, // Pass total to payment page
                            shoppingBag: _shoppingBag, // Pass the bag data
                          ),
                        ),
                      );
                    } else {
                      // Show a snack bar if the shopping bag is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Your shopping bag is empty!")),
                      );
                    }
                  },
                  child: const Text('Proceed to Payment'), // Proceed button
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
