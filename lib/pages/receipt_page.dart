import 'package:flutter/material.dart';
import 'rating_page.dart'; // Import the RatingPage to navigate for feedback

class ReceiptPage extends StatelessWidget {
  // Variables to store the shopping bag, total amount, discount, and takeaway status
  final List<Map<String, dynamic>> shoppingBag;
  final double totalAmount;
  final double discount;
  final bool isTakeaway;

  // Constructor to initialize the receipt page with the necessary data
  const ReceiptPage(
      {super.key,
      required this.shoppingBag,
      required this.totalAmount,
      required this.discount,
      required this.isTakeaway});

  // Method to calculate the final amount considering tax, takeaway fee, and discount
  double getFinalAmount(double totalAmount) {
    double serviceTax = 0.06; // Service tax (6%)
    double takeawayFee = 0.20; // Takeaway charge (RM0.20)
    double taxAmount = totalAmount * serviceTax; // Calculate service tax
    double takeawayCharge =
        isTakeaway ? takeawayFee : 0.0; // Apply takeaway charge if selected
    return totalAmount +
        taxAmount +
        takeawayCharge -
        discount; // Calculate final amount
  }

  @override
  Widget build(BuildContext context) {
    double finalAmount =
        getFinalAmount(totalAmount); // Get the final total amount

    return Scaffold(
      appBar: AppBar(title: const Text("Receipt")), // Title of the page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Receipt:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Display the list of items purchased
            const Text('Items Purchased:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount:
                    shoppingBag.length, // Number of items in the shopping bag
                itemBuilder: (context, index) {
                  var item = shoppingBag[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      leading: Image.asset(
                        item['image']!, // Display item image
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['name']), // Display item name
                      subtitle: Text(
                        'RM${(item['price'] * item['quantity']).toStringAsFixed(2)} x ${item['quantity']}',
                        style: const TextStyle(
                            fontSize: 14), // Price and quantity details
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Pricing breakdown section
            Text('Base Price: RM${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            Text(
                'Service Tax (6%): RM${(totalAmount * 0.06).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            const Text('Takeaway (Bag Charge): RM0.20',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Discount: RM${discount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Total Amount: RM${finalAmount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Button to navigate to the RatingPage for user feedback
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RatingPage(
                        shoppingBag:
                            shoppingBag), // Pass shopping bag to the RatingPage
                  ),
                );
              },
              child: const Text("Rate Items"), // Text displayed on the button
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize:
                    const Size(double.infinity, 50), // Full width button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
