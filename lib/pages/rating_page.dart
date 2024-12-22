import 'package:flutter/material.dart';

class RatingPage extends StatefulWidget {
  final List<Map<String, dynamic>> shoppingBag;

  const RatingPage({super.key, required this.shoppingBag});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  // Map to store ratings (from 0 to 5) for each item in the shopping bag
  Map<int, double> ratings = {};
  // Map to store review text for each item, associated with its index
  Map<int, TextEditingController> reviewControllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize ratings and review controllers with default values for each item
    for (int i = 0; i < widget.shoppingBag.length; i++) {
      ratings[i] = 0.0; // Default rating is 0
      reviewControllers[i] = TextEditingController(); // Empty review text field
    }
  }

  // Function to display a dialog with the ratings and reviews entered by the user
  void showReviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your Ratings & Reviews'), // Dialog title
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.shoppingBag.map((item) {
                int index = widget.shoppingBag.indexOf(item); // Get item index
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the item name, rating, and review for each item
                      Text(item['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Rating: ${ratings[index]?.toStringAsFixed(1)}'),
                      Text(
                          'Review: ${reviewControllers[index]?.text.isEmpty ?? true ? "No Review" : reviewControllers[index]?.text}'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Items')), // App bar title
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget
              .shoppingBag.length, // Iterate through the shopping bag items
          itemBuilder: (context, index) {
            var item = widget.shoppingBag[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: ListTile(
                leading: Image.asset(item['image']!,
                    width: 50, height: 50, fit: BoxFit.cover),
                title: Text(item['name']), // Display the item name
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Slider for rating
                    Text('Rate this item:'),
                    Slider(
                      value: ratings[index]!, // Current rating value
                      min: 0, // Minimum rating value (0)
                      max: 5, // Maximum rating value (5)
                      divisions: 5, // Divide the slider into 5 parts
                      label: ratings[index]!
                          .toString(), // Display the current rating as the label
                      onChanged: (value) {
                        setState(() {
                          ratings[index] =
                              value; // Update the rating when the slider changes
                        });
                      },
                    ),
                    Text(
                        'Rating: ${ratings[index]?.toStringAsFixed(1)}'), // Display the current rating
                    const SizedBox(height: 10),
                    Text('Write a review:'),
                    TextField(
                      controller: reviewControllers[
                          index], // Attach the review controller
                      maxLines: 3, // Limit the review text field to 3 lines
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'Enter your review...', // Hint text for review input
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed:
              showReviewDialog, // Show the dialog when the button is pressed
          child: const Text('Submit Feedback'), // Button text
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            minimumSize: const Size(double.infinity, 50), // Full-width button
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
