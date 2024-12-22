import 'package:flutter/material.dart';
import 'user_details_page.dart'; // Import UserDetailsPage for the first tab
import 'menu_page.dart'; // Import MenuPage for the second tab

class NavigationHome extends StatefulWidget {
  const NavigationHome({super.key}); // Constructor for NavigationHome widget

  @override
  State<NavigationHome> createState() => _NavigationHomeState();
}

class _NavigationHomeState extends State<NavigationHome> {
  int _currentIndex = 0; // Keep track of the current tab index

  // List of pages corresponding to the tabs in the bottom navigation
  final List<Widget> _pages = [
    const UserDetailsPage(), // First tab page: UserDetailsPage
    const MenuPage(), // Second tab page: MenuPage
  ];

  // Titles corresponding to each tab, used in AppBar
  final List<String> _titles = [
    'User Details', // Title for the first tab
    'Menu Packages', // Title for the second tab
  ];

  // Method to handle changes when a tab is tapped
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index and switch the page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[
            _currentIndex]), // Set the AppBar title based on the selected tab
      ),
      body: _pages[_currentIndex], // Display the content of the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Highlight the current tab
        onTap: _onTabTapped, // Invoke the method to handle tab change
        selectedItemColor: Color(0xFF6857a5), // Color for the selected tab
        unselectedItemColor: Colors.black, // Color for unselected tabs
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icon for the first tab
            label: 'Details', // Label for the first tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu), // Icon for the second tab
            label: 'Menu', // Label for the second tab
          ),
        ],
      ),
    );
  }
}
