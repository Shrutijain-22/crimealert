import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrimeMapPage extends StatefulWidget {
  const CrimeMapPage({super.key});

  @override
  State<CrimeMapPage> createState() => _CrimeMapPageState();
}

class _CrimeMapPageState extends State<CrimeMapPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  LatLng? _currentLocation;
  LatLng? _searchedLocation;
  List<LatLng> _routePoints = [];

  final List<Map<String, dynamic>> _demoCrimes = [
    // Delhi crimes
    {
      'location': LatLng(28.6129, 77.2295),
      'type': 'Theft',
      'date': '2023-11-20',
    },
    {
      'location': LatLng(28.6219, 77.2090),
      'type': 'Vandalism',
      'date': '2023-11-19',
    },
    {
      'location': LatLng(28.6150, 77.2100),
      'type': 'Assault',
      'date': '2023-11-18',
    },
    // Jaipur crimes
    {
      'location': LatLng(26.9124, 75.7873),
      'type': 'Robbery',
      'date': '2023-11-20',
    },
    {
      'location': LatLng(26.9220, 75.7880),
      'type': 'Vehicle Theft',
      'date': '2023-11-19',
    },
    {
      'location': LatLng(26.9150, 75.7900),
      'type': 'Suspicious Activity',
      'date': '2023-11-18',
    },
    // Jaipur crimes (Mahapura to Hawa Mahal route)
    {
      'location': LatLng(26.8862, 75.8182), // Near Mahapura
      'type': 'Vehicle Theft',
      'date': '2023-11-21',
    },
    {
      'location': LatLng(26.8998, 75.8111), // Shivdaspura Road
      'type': 'Robbery',
      'date': '2023-11-20',
    },
    {
      'location': LatLng(26.9157, 75.8055), // Goner Road
      'type': 'Assault',
      'date': '2023-11-19',
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation!, 13.0);
    });
  }

  Future<void> _searchLocation(String query) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          _searchedLocation = LatLng(
            double.parse(data[0]['lat']),
            double.parse(data[0]['lon']),
          );
          _mapController.move(_searchedLocation!, 13.0);
        });
        await _getRoute();
      }
    }
  }

  Future<void> _getRoute() async {
    if (_currentLocation == null || _searchedLocation == null) return;

    // Note: You'll need to sign up for OpenRouteService and get an API key
    final response = await http.get(
      Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf624868ec5121e1604948add6d532deec24ce&start=${_currentLocation!.longitude},${_currentLocation!.latitude}&end=${_searchedLocation!.longitude},${_searchedLocation!.latitude}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['features'][0]['geometry']['coordinates'] as List;
      setState(() {
        _routePoints = coordinates
            .map((coord) => LatLng(coord[1] as double, coord[0] as double))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crime Map'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location...',
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blue),
                  onPressed: () => _searchLocation(_searchController.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: _searchLocation,
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLocation ?? LatLng(28.6139, 77.2090),
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                PolylineLayer(
                  polylines: [
                    if (_routePoints.isNotEmpty)
                      Polyline(
                        points: _routePoints,
                        color: Colors.blue,
                        strokeWidth: 3,
                      ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    // Existing markers for current and searched locations
                    if (_currentLocation != null)
                      Marker(
                        point: _currentLocation!,
                        width: 80,
                        height: 80,
                        builder: (context) => const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    if (_searchedLocation != null)
                      Marker(
                        point: _searchedLocation!,
                        width: 80,
                        height: 80,
                        builder: (context) => const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    // Add crime markers
                    ..._demoCrimes.map(
                      (crime) => Marker(
                        point: crime['location'] as LatLng,
                        width: 80,
                        height: 80,
                        builder: (context) => Tooltip(
                          message: '${crime['type']}\n${crime['date']}',
                          child: const Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
