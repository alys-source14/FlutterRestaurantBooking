import 'package:flutter/material.dart';
import 'receipt_page.dart'; // Import the receipt page

class PaymentPage extends StatefulWidget {
  // Payment page receives the total amount and shopping bag data.
  final double totalAmount;
  final List<Map<String, dynamic>> shoppingBag;

  // Constructor to initialize the page with the provided amount and shopping bag data
  const PaymentPage(
      {super.key, required this.totalAmount, required this.shoppingBag});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Controller for the discount text field
  final TextEditingController discountController = TextEditingController();
  bool isTakeaway = false; // Flag to check if it's a takeaway order
  double discount = 0.0; // The discount value
  double serviceTax = 0.06; // Service tax rate (6%)
  double takeawayFee = 0.20; // Takeaway bag charge (fixed)

  // Method to calculate the final amount to be paid after applying tax, takeaway fee, and discount
  double getFinalAmount() {
    double taxAmount = widget.totalAmount * serviceTax; // Calculate service tax
    double takeawayCharge =
        isTakeaway ? takeawayFee : 0.0; // Takeaway fee if selected
    return widget.totalAmount +
        taxAmount +
        takeawayCharge -
        discount; // Final total
  }

  // Method to show a confirmation dialog before proceeding with payment
  void showConfirmationDialog() {
    final finalAmount = getFinalAmount(); // Get the final amount to be paid

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Payment"),
          content: Text(
              "You are about to pay RM${finalAmount.toStringAsFixed(2)}. Do you want to proceed?"),
          actions: [
            // Cancel button to close the dialog
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            // Confirm button to proceed with payment
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment Successful!")),
                );

                // Navigate to the Receipt Page after a successful payment
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiptPage(
                      shoppingBag:
                          widget.shoppingBag, // Pass shopping bag items
                      totalAmount:
                          widget.totalAmount, // Pass the base total amount
                      discount: discount, // Pass the discount
                      isTakeaway: isTakeaway, // Pass takeaway status
                    ),
                  ),
                );
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double finalAmount = getFinalAmount(); // Get the final amount to display

    return Scaffold(
      appBar: AppBar(title: const Text("Payment Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display shopping bag items
            const Text('Items in your shopping bag:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget
                    .shoppingBag.length, // Number of items in the shopping bag
                itemBuilder: (context, index) {
                  var item = widget.shoppingBag[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      leading: Image.asset(
                        item['image']!, // Display the image of the item
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['name']), // Item name
                      subtitle: Text(
                        'RM${(item['price'] * item['quantity']).toStringAsFixed(2)} x ${item['quantity']}',
                        style: const TextStyle(
                            fontSize: 14), // Item price and quantity
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Pricing details section
            Text('Base Price: RM${widget.totalAmount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
                'Service Tax (6%): RM${(widget.totalAmount * serviceTax).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            // Takeaway checkbox to select if it's a takeaway order
            Row(
              children: [
                const Text('Takeaway (Bag Charge): RM0.20',
                    style: TextStyle(fontSize: 16)),
                Checkbox(
                  value: isTakeaway,
                  onChanged: (value) {
                    setState(() {
                      isTakeaway = value!; // Update takeaway status
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Text field to enter a discount code
            TextField(
              controller: discountController,
              decoration: const InputDecoration(
                  labelText: 'Enter Discount Code',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12)),
              onChanged: (value) {
                setState(() {
                  // Apply discount if the correct code is entered
                  discount = value == 'DISCOUNT10' ? 10.0 : 0.0;
                });
              },
            ),
            const SizedBox(height: 10),
            Text('Discount: RM${discount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Total Amount: RM${finalAmount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Confirm payment button
            ElevatedButton(
              onPressed:
                  showConfirmationDialog, // Show confirmation dialog on press
              child: const Text("Pay"),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
