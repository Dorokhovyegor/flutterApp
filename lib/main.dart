import "dart:async";

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfirstflutterup/location.dart' as location;

/*void main() {
  runApp(MyApp());
}*/

void main() => runApp(GoogleMapApp());

class GoogleMapApp extends StatefulWidget {
  @override
  _GoogleMapAppState createState() => _GoogleMapAppState();
}

class _GoogleMapAppState extends State<GoogleMapApp> {
  final Map<String, Marker> _markers = {}; // ключ -- имя офиса
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await location.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
            markerId: MarkerId(office.name),
            position: LatLng(office.lat, office.lng),
            infoWindow:
                InfoWindow(title: office.name, snippet: office.address));
        _markers[office.name] = marker; // добавляем новый маркер
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Google Maps Sample"),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
              target: const LatLng(0,0),
              zoom: 2.0
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}