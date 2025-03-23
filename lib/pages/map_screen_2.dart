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
  // Selected location coordinates and address
  LatLng? _selectedLocation;
  String? _selectedAddress;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation; // Initialize with the passed location
    _selectedAddress = ''; // Optional: Set an initial address if needed
  }

  // Function to search for location
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    final String url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5"; // limit results

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        setState(() {
          _suggestions = data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location not found")),
        );
      }
    } else {
      print("Failed to fetch location data");
    }
  }

  // Update selected location when a suggestion is tapped
  void suggestionSelected(String address, double lat, double lon) {
    setState(() {
      _selectedLocation = LatLng(lat, lon);
      _selectedAddress = address; // Store the address of the selected location
      _searchController.text = address;
      _suggestions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search Location...",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchLocation(_searchController.text);
                  },
                ),
              ),
              onChanged: (text) {
                _searchLocation(_searchController.text);
              },
            ),
          ),

          // Suggestions list
          if (_suggestions.isNotEmpty)
            Container(
              height: 200,
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  final address = suggestion['display_name'];
                  final lat = double.parse(suggestion['lat']);
                  final lon = double.parse(suggestion['lon']);

                  return ListTile(
                    title: Text(address),
                    subtitle: Text("Coordinates: $lat, $lon"),
                    onTap: () {
                      suggestionSelected(address, lat, lon); // Update location on tap
                    },
                  );
                },
              ),
            ),

          // Map displaying the selected location
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _selectedLocation ?? LatLng(0.0, 0.0), // Default to (0,0) if no location
                zoom: 14.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedLocation = point; // Update location on map tap
                    _selectedAddress = null; // Reset the address text if tapping on map
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
                        Icons.location_on_outlined,
                        color: Colors.black,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Display the selected address (if any) or coordinates
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _selectedAddress ??
                  "Selected Coordinates: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}",
              style: TextStyle(fontSize: 18),
            ),
          ),

          // Button to confirm location selection
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, _selectedLocation); // Return selected location to previous screen
              },
              child: Text(
                "Confirm Location",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
