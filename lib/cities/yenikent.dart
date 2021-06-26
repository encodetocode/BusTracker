import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Yenikent extends StatefulWidget {
  YenikentState createState() => YenikentState();
}

class YenikentState extends State<Yenikent> {
  @override
  void onMapCreated(controller) {
    setState(() {
      controller;
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.2297683, 33.3242372),
    zoom: 14.4746,
  );
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      GoogleMap(
        initialCameraPosition: _kGooglePlex,
        zoomControlsEnabled: false,
        onMapCreated: onMapCreated,
        // markers: _googleMapsServices.markers,
        // polylines: _googleMapsServices.polyLines,
        // trafficEnabled: true,
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton(
          child: Icon(Icons.directions),
          onPressed: () {},
        ),
      )
    ]));
  }
}
