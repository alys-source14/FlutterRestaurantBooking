import 'package:flutter/material.dart';
import 'pages/splash_page.dart'; // Import the SplashPage which is the initial screen

void main() {
  runApp(const RestaurantBookingApp()); // Run the main app widget
}

class RestaurantBookingApp extends StatelessWidget {
  const RestaurantBookingApp(
      {super.key}); // Constructor for RestaurantBookingApp

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Disable the debug banner in the top-right corner
      title:
          'Restaurant Booking', // Set the title for the app (appears in task switcher)
      theme: ThemeData(
          primarySwatch:
              Colors.blue), // Define the app's theme (blue color scheme)
      home:
          const SplashPage(), // Set the home page to SplashPage, which is the first screen users will see
    );
  }
}
