import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;

  const MapScreen({super.key, required this.initialLocation});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Selected location coordinates
  LatLng ?_selectedLocation;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    final String url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        setState(() {
          _selectedLocation = LatLng(lat, lon);
        });
      } else {
        // If no location is found, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location not found")),
        );
      }
    } else {
      print("Failed to fetch location data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
        actions: [
          // Search Button
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _searchLocation(_searchController.text);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search Location",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchLocation(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          // FlutterMap widget to display OpenStreetMap
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _selectedLocation, 
                zoom: 14.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedLocation = point; 
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", // OpenStreetMap tile URL
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _selectedLocation!,
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Selected Coordinates: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}",
              style: TextStyle(fontSize: 18),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _selectedLocation); 
              },
              child: Text("Confirm Selection"),
            ),
          ),
        ],
      ),
    );
  }
}
