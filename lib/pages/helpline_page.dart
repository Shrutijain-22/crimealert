import 'package:flutter/material.dart';

class HelplinePage extends StatelessWidget {
  const HelplinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpline Numbers'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          HelplineCard(
            title: 'Police',
            number: '100',
            icon: Icons.local_police,
          ),
          HelplineCard(
            title: 'Ambulance',
            number: '102',
            icon: Icons.healing,
          ),
          HelplineCard(
            title: 'Fire',
            number: '101',
            icon: Icons.fire_truck,
          ),
          HelplineCard(
            title: 'Women Helpline',
            number: '1091',
            icon: Icons.woman,
          ),
        ],
      ),
    );
  }
}

class HelplineCard extends StatelessWidget {
  final String title;
  final String number;
  final IconData icon;

  const HelplineCard({
    super.key,
    required this.title,
    required this.number,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title),
        subtitle: Text(number),
        trailing: IconButton(
          icon: const Icon(Icons.phone),
          onPressed: () {},
        ),
      ),
    );
  }
}
