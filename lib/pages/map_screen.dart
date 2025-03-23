import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;
  const MapScreen({super.key, required this.initialLocation});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {


  // Selected location coordinates
  LatLng _selectedLocation = LatLng(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: Column(
        children: [
          // FlutterMap widget to display OpenStreetMap
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _selectedLocation, // Start from this location
                zoom: 14.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedLocation = point; // Update selected location
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", // OpenStreetMap tile URL
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _selectedLocation,
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
          // Display selected coordinates below the map
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Selected Coordinates: ${_selectedLocation.latitude}, ${_selectedLocation.longitude}",
              style: TextStyle(fontSize: 18),
            ),
          ),
          // Button to confirm the selection and go back to HomePage
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _selectedLocation); // Return selected coordinates
              },
              child: Text("Confirm Selection"),
            ),
          ),
        ],
      ),
    );
  }
}
