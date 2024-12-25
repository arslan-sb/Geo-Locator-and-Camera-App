import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  LatLng _currentLocation = LatLng(0, 0);

  Future<void> _getCurrentLocation() async {
    final Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if GPS is enabled and request permissions
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    // Get the current location
    final loc = await location.getLocation();

    setState(() {
      _currentLocation = LatLng(loc.latitude!, loc.longitude!);
    });

    // Animate the camera to the current location
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation, 15),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Current Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId("current_location"),
            position: _currentLocation,
          )
        },
        onMapCreated: (controller) {
          _controller = controller;
          // Ensure the camera updates after the map is created
          if (_currentLocation.latitude != 0 && _currentLocation.longitude != 0) {
            _controller!.animateCamera(
              CameraUpdate.newLatLngZoom(_currentLocation, 15),
            );
          }
        },
      ),
    );
  }
}
