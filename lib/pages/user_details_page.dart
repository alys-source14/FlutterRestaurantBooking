import 'package:flutter/material.dart';
import 'menu_page.dart'; // Import the MenuPage, which the user navigates to after confirming the details

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key}); // Constructor for UserDetailsPage widget

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _formKey = GlobalKey<
      FormState>(); // Global key for the form to validate and save input data

  // Variables to store user input for reservation details
  String name = '', address = '', phone = '', email = '', request = '';
  DateTime? reservationDate;
  TimeOfDay? reservationTime;
  String? duration;
  int guests = 1;

  // Function to show the time picker for reservation time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Default time is the current time
    );
    if (picked != null && picked != reservationTime) {
      setState(() {
        reservationTime =
            picked; // Update reservation time with the selected time
      });
    }
  }

  // Function to show a confirmation dialog with the entered details before proceeding
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: $name'), // Display name
              Text('Address: $address'), // Display address
              Text('Phone: $phone'), // Display phone number
              Text('Email: $email'), // Display email
              Text('Guests: $guests'), // Display number of guests
              Text(
                  'Reservation Date: ${reservationDate?.toLocal()}'), // Display selected reservation date
              Text(
                  'Reservation Time: ${reservationTime?.format(context)}'), // Display selected reservation time
              Text('Duration: $duration'), // Display selected duration
              Text(
                  'Additional Request: $request'), // Display additional request
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Close the dialog without action
              child: const Text("Edit"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MenuPage()), // Navigate to MenuPage after confirmation
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the form
        child: Form(
          key: _formKey, // Use form key to validate and save form data
          child: ListView(
            children: [
              // Text form fields to get user input for each reservation detail
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty
                    ? 'Name is required.'
                    : null, // Validate that name is not empty
                onSaved: (value) => name = value!, // Save the entered name
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty
                    ? 'Address is required.'
                    : null, // Validate that address is not empty
                onSaved: (value) =>
                    address = value!, // Save the entered address
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone No'),
                validator: (value) => value!.isEmpty
                    ? 'Phone number is required.'
                    : null, // Validate that phone number is not empty
                onSaved: (value) =>
                    phone = value!, // Save the entered phone number
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty
                    ? 'Email is required.'
                    : null, // Validate that email is not empty
                onSaved: (value) => email = value!, // Save the entered email
              ),
              const SizedBox(height: 10),
              // Button to pick a reservation date
              ElevatedButton(
                onPressed: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), // Default to today's date
                    firstDate: DateTime
                        .now(), // Allow selecting from today's date onward
                    lastDate:
                        DateTime(2100), // Allow selecting until the year 2100
                  );
                  if (date != null) {
                    setState(() =>
                        reservationDate = date); // Update reservation date
                  }
                },
                child: Text(reservationDate == null
                    ? 'Select Reservation Date' // Prompt user if no date is selected
                    : 'Selected: ${reservationDate!.toLocal()}'), // Display the selected reservation date
              ),
              const SizedBox(height: 10),
              // Button to pick a reservation time
              ElevatedButton(
                onPressed: () => _selectTime(context), // Show time picker
                child: Text(reservationTime == null
                    ? 'Select Reservation Time' // Prompt user if no time is selected
                    : 'Selected: ${reservationTime!.format(context)}'), // Display the selected reservation time
              ),
              const SizedBox(height: 10),
              // Dropdown to select reservation duration
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Duration'),
                items: ['3 hours', '4 hours', '5 hours']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(
                    () => duration = value), // Update selected duration
                validator: (value) => value == null
                    ? 'Select duration'
                    : null, // Validate that a duration is selected
              ),
              // Text form field for additional requests
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Additional Request'),
                onSaved: (value) =>
                    request = value ?? '', // Save the additional request
              ),
              // Text form field for the number of guests
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Number of Guests'),
                keyboardType: TextInputType.number, // Allow only numeric input
                validator: (value) =>
                    value!.isEmpty || int.tryParse(value) == null
                        ? 'Enter a valid number'
                        : null, // Validate that the value is a valid number
                onSaved: (value) =>
                    guests = int.parse(value!), // Save the number of guests
              ),
              const SizedBox(height: 20),
              // Submit button to validate and show confirmation dialog
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Validate the form
                    _formKey.currentState!.save(); // Save form data
                    _showConfirmationDialog(); // Show confirmation dialog
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
