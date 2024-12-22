import 'package:flutter/material.dart';
import 'navigation_home.dart'; // Import the NavigationHome page, which the app navigates to after the splash screen

class SplashPage extends StatelessWidget {
  const SplashPage({super.key}); // Constructor for SplashPage widget

  @override
  Widget build(BuildContext context) {
    // Set a delayed function to navigate to the next page (NavigationHome) after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const NavigationHome()), // Replace current page with NavigationHome
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFF6857a5), // Set the background color to purple for the splash screen
      body: Center(
        child: Text(
          'Restaurant Booking', // Display the app name on the splash screen
          style: TextStyle(
            fontSize: 24, // Set font size
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Set text to bold
          ),
        ),
      ),
    );
  }
}
