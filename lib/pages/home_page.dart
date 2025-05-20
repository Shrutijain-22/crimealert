import 'package:flutter/material.dart';
import 'report_crime_page.dart';
import 'profile_page.dart';
import 'helpline_page.dart';
import 'crime_map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crime Alert'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelplinePage()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Recent Alerts',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: const Text('Vehicle Theft'),
              subtitle: const Text('Near Mahapura, Jaipur'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: const Text('Robbery'),
              subtitle: const Text('Shivdaspura Road, Jaipur'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: const Text('Assault'),
              subtitle: const Text('Goner Road, Jaipur'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('SOS Alert Sent!'),
              backgroundColor: Colors.red,
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Text('SOS', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6.0,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => setState(() => _selectedIndex = 0),
              color: _selectedIndex == 0 ? Colors.red : null,
            ),
            IconButton(
              icon: const Icon(Icons.report_problem),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportCrimePage()),
                );
              },
            ),
            const SizedBox(width: 40), // Space for FAB
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CrimeMapPage()),
              ),
              color: _selectedIndex == 1 ? Colors.red : null,
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
