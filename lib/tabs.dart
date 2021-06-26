import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
// import 'dart:html';

import 'package:busmap/track.dart';
import 'package:busmap/track2.dart';
import 'package:busmap/tracker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'distance.dart';
import 'functions.dart';

GoogleMapController controller;

class Gonyeli extends StatefulWidget {
  // final DistanceMatrix distanceMatrix;

  GonyeliState createState() => GonyeliState();

  // Gonyeli({this.distanceMatrix});
}

class GonyeliState extends State<Gonyeli> {
  GoogleMapController _controller;
  final api = 'AIzaSyAB85B9V9XjstZ9_BT_GF70Jb6AitZvseM';
  Set<Polyline> _polylines = HashSet<Polyline>();
  Set<Marker> _markers = HashSet<Marker>();
  Set<Marker> markers = HashSet<Marker>();
  final track = Tracker();
  final currentdriverlocation = Position();

  // List<LatLng> polylineLatLongs = List<LatLng>();
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyAB85B9V9XjstZ9_BT_GF70Jb6AitZvseM");

  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  List<LatLng> way = [
    LatLng(35.2081665, 33.3168829),
    LatLng(35.2080342, 33.3127617),
    LatLng(35.2083147, 33.3079388),
    LatLng(35.2094003, 33.2985768),
    LatLng(35.2092529, 33.3073316),
    LatLng(35.2122594, 33.3072266),
    LatLng(35.2183096, 33.3035460),
    LatLng(35.2217501, 33.3006690),
    LatLng(35.2145494, 33.3083649),
    LatLng(35.2124804, 33.3107219),
    LatLng(35.2103317, 33.3144706),
    LatLng(35.2096584, 33.3171102),
  ];

  // List<String> stations = [
  //   'first',
  //   'second',
  //   'third',
  //   'fourth',
  //   'fifth',
  //   'sixth',
  //   'seventh',
  //   'eighth',
  //   'ninth',
  //   'tenth',
  //   'eleventh',
  //   'twelvth',
  // ];
  Future<void> _getWayPoints() async {
    final orgin = new LatLng(35.2297683, 33.3242372);
    final des = new LatLng(35.2297683, 33.3242372);
    final dess = LatLng(35.2103317, 33.3144706);

    //   polylineLatLongs = await googleMapPolyline.getCoordinatesWithLocation(
    //       origin: LatLng(35.2297683, 33.3242372),
    //       destination: LatLng(35.2081665, 33.3168829),
    //       mode: RouteMode.driving);

    String route = await _googleMapsServices.getRouteCoordinates(orgin, des,
        waypoints: way);
    _googleMapsServices.createRoute(route);
    _googleMapsServices.createMarkers(route);
    // _googleMapsServices.getDuration(orgin, way);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.2297683, 33.3242372),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getWayPoints();

    loadmap2(_googleMapsServices.polyLines, _kGooglePlex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      loadmap2(_googleMapsServices.polyLines, _kGooglePlex),
      Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FloatingActionButton(
              child: Icon(Icons.directions),
              onPressed: () {
                setState(() {
                  _getWayPoints();
                });
              },
            ),
          )),
    ]));
  }
}
