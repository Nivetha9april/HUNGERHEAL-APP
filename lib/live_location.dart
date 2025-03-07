import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveLocationPage extends StatefulWidget {
  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getLiveLocation();
    _fetchAllUsersLocations(); // Fetch all users' locations initially
  }

  Future<void> _getLiveLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied.");
    }

    // Listen for live location updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _updateMarker(position);
        _updateFirestore(position);
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );
    });
  }

  // 🔹 Add or update user's live location marker
  void _updateMarker(Position position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("currentUser"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: "Your Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  // 🔹 Store live location in Firestore (for donors, recipients, and volunteers)
  Future<void> _updateFirestore(Position position) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get user role (donor, recipient, or volunteer)
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        String role = userDoc.data()?["role"] ?? "unknown"; // Retrieve user role

        await FirebaseFirestore.instance.collection(role).doc(user.uid).set({
          "name": userDoc.data()?["name"] ?? "Unknown",
          "latitude": position.latitude,
          "longitude": position.longitude,
          "lastUpdated": DateTime.now(),
        }, SetOptions(merge: true));
      }
    }
  }

  // 🔹 Fetch and display all users' locations
  void _fetchAllUsersLocations() {
    _listenToCollection("donors");
    _listenToCollection("recipients");
    _listenToCollection("volunteers");
  }

  void _listenToCollection(String collection) {
    FirebaseFirestore.instance.collection(collection).snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        double lat = data["latitude"];
        double lng = data["longitude"];
        String name = data["name"] ?? "Unknown";

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(title: "$name ($collection)"),
              icon: collection == "volunteers"
                  ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
                  : collection == "recipients"
                      ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
                      : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location"), backgroundColor: Colors.black),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition != null
              ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
              : LatLng(20.5937, 78.9629), // Default India location
          zoom: 12,
        ),
        markers: _markers,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
