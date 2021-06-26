import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
// import 'dart:html';
import 'package:busmap/display_tracker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'functions.dart';

GoogleMapController controller;

class Gonyeli extends StatefulWidget {
  GonyeliState createState() => GonyeliState();
}

class GonyeliState extends State<Gonyeli> {
  GoogleMapController _controller;
  final api = 'AIzaSyAB85B9V9XjstZ9_BT_GF70Jb6AitZvseM';
  Set<Polyline> _polylines = HashSet<Polyline>();
  Set<Marker> _markers = HashSet<Marker>();
  Set<Marker> markers = HashSet<Marker>();
  final currentdriverlocation = Position();
  DisplayOnmap display = DisplayOnmap();

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

  List<String> stations = [
    'first',
    'second',
    'third',
    'fourth',
    'fifth',
    'sixth',
    'seventh',
    'eighth',
    'ninth',
    'tenth',
    'eleventh',
    'twelvth',
  ];
  Future<void> _getWayPoints() async {
    final orgin = new LatLng(35.2297683, 33.3242372);
    final des = new LatLng(35.2297683, 33.3242372);

    //   polylineLatLongs = await googleMapPolyline.getCoordinatesWithLocation(
    //       origin: LatLng(35.2297683, 33.3242372),
    //       destination: LatLng(35.2081665, 33.3168829),
    //       mode: RouteMode.driving);

    String route = await _googleMapsServices.getRouteCoordinates(orgin, des,
        waypoints: way);
    _googleMapsServices.createRoute(route);
    _googleMapsServices.createMarkers(route);
  }

  // Future<Stream> mymarkers()  async{
  //   StreamBuilder(
  //     stream: FirebaseFirestore.instance.collection("products").snapshots(),
  //     builder: ,);
  // }
  void _createMarkers() async {
    for (int i = 0; i < (way.length - 1); i++) {
      markers.add(Marker(
        markerId: MarkerId('${stations[i]}'),
        position: new LatLng(way[i].latitude, way[i].longitude),
        infoWindow: InfoWindow(
          onTap: () => "${stations[i]}",
        ),
      ));
    }
  }

  void onMapCreated(controller) {
    // List<LatLng> polylineLatLongs = List<LatLng>();
    // polylineLatLongs.add(LatLng(35.2297683, 33.3242372));
    // polylineLatLongs.add(LatLng(35.2081665, 33.3168829));
    // polylineLatLongs.add(LatLng(35.2080342, 33.3127617));
    // polylineLatLongs.add(LatLng(35.2083147, 33.3079388));
    // polylineLatLongs.add(LatLng(35.2094003, 33.2985768));
    // polylineLatLongs.add(LatLng(35.2092529, 33.3073316));
    // polylineLatLongs.add(LatLng(35.2122594, 33.3072266));
    // polylineLatLongs.add(LatLng(35.2183096, 33.3035460));
    // polylineLatLongs.add(LatLng(35.2217501, 33.3006690));
    // polylineLatLongs.add(LatLng(35.2145494, 33.3083649));
    // polylineLatLongs.add(LatLng(35.2124804, 33.3107219));
    // polylineLatLongs.add(LatLng(35.2103317, 33.3144706));
    // polylineLatLongs.add(LatLng(35.2096584, 33.3171102));
    // polylineLatLongs.add(LatLng(35.2297683, 33.3242372));
    setState(() {
      controller;
    });
  }

  getmarkers() async {
    List clients = [];
    FirebaseFirestore.instance
        .collection('city')
        .doc('city_1')
        .collection('markers')
        .get()
        .then((docs) {
      if (docs.docs.isNotEmpty) {
        var num = docs.docs.length;
        log("$num");
        _markers.clear();
        for (int i = 0; i < docs.docs.length; ++i) {
          clients.add(docs.docs[i].data());
          initMarker(docs.docs[i].data());
        }
      }
    });
  }

  initMarker(client) {
    // _markers.then(val){
    print("$client");
    var station = client['station_name'];

    _markers.add(Marker(
        position:
            LatLng(client['location'].latitude, client['location'].longitude),
        draggable: false,
        infoWindow: InfoWindow(title: client['station_name']),
        markerId: MarkerId('$station')));
    // };
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.2297683, 33.3242372),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getWayPoints();
    // getmarkers();
    display.retrivemarkers();
  }

  // void showPlacePicker() async {
  //   LocationResult result = await Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => PlacePicker("YOUR API KEY")));

  //   // Handle the result in your way
  //   print(result);
  // }
  @override
  Widget build(BuildContext context) {
    var oka;
    oka = _googleMapsServices.mins;
    return Scaffold(
        body: Stack(children: [
      GoogleMap(
        initialCameraPosition: _kGooglePlex,
        zoomControlsEnabled: false,
        onMapCreated: onMapCreated,
        markers: _markers,
        polylines: _googleMapsServices.polyLines,
        // trafficEnabled: true,
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton(
          child: Icon(Icons.directions),
          onPressed: () {
            setState(() {
              _getWayPoints();
              getmarkers();
            });
          },
        ),
      ),

      Padding(
          padding: EdgeInsets.all(10),
          child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                child: Text("$oka"),
              )))
      // FlatButton(
      //     onPressed: () {
      //       showPlacePicker();
      //     },
      //     child: Text("choose place"))
    ]));
  }
}

class Lefkosa extends StatefulWidget {
  LefkosaState createState() => LefkosaState();
}

class LefkosaState extends State<Lefkosa> {
  @override
  void onMapCreated(controller) {
    // List<LatLng> polylineLatLongs = List<LatLng>();
    // polylineLatLongs.add(LatLng(35.2297683, 33.3242372));
    // polylineLatLongs.add(LatLng(35.2081665, 33.3168829));
    // polylineLatLongs.add(LatLng(35.2080342, 33.3127617));
    // polylineLatLongs.add(LatLng(35.2083147, 33.3079388));
    // polylineLatLongs.add(LatLng(35.2094003, 33.2985768));
    // polylineLatLongs.add(LatLng(35.2092529, 33.3073316));
    // polylineLatLongs.add(LatLng(35.2122594, 33.3072266));
    // polylineLatLongs.add(LatLng(35.2183096, 33.3035460));
    // polylineLatLongs.add(LatLng(35.2217501, 33.3006690));
    // polylineLatLongs.add(LatLng(35.2145494, 33.3083649));
    // polylineLatLongs.add(LatLng(35.2124804, 33.3107219));
    // polylineLatLongs.add(LatLng(35.2103317, 33.3144706));
    // polylineLatLongs.add(LatLng(35.2096584, 33.3171102));
    // polylineLatLongs.add(LatLng(35.2297683, 33.3242372));
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
      // FlatButton(
      //     onPressed: () {
      //       showPlacePicker();
      //     },
      //     child: Text("choose place"))
    ]));
  }
}

class Yenikent extends StatefulWidget {
  YenikentState createState() => YenikentState();
}

class YenikentState extends State<Yenikent> {
  @override
  void onMapCreated(controller) {
    // List<LatLng> polylineLatLongs = List<LatLng>();
    // polylineLatLongs.add(LatLng(35.2297683, 33.3242372));
    // polylineLatLongs.add(LatLng(35.2081665, 33.3168829));
    // polylineLatLongs.add(LatLng(35.2080342, 33.3127617));
    // polylineLatLongs.add(LatLng(35.2083147, 33.3079388));
    // polylineLatLongs.add(LatLng(35.2094003, 33.2985768));
    // polylineLatLongs.add(LatLng(35.2092529, 33.3073316));
    // polylineLatLongs.add(LatLng(35.2122594, 33.3072266));
    // polylineLatLongs.add(LatLng(35.2183096, 33.3035460));
    // polylineLatLongs.add(LatLng(35.2217501, 33.3006690));
    // polylineLatLongs.add(LatLng(35.2145494, 33.3083649));
    // polylineLatLongs.add(LatLng(35.2124804, 33.3107219));
    // polylineLatLongs.add(LatLng(35.2103317, 33.3144706));
    // polylineLatLongs.add(LatLng(35.2096584, 33.3171102));
    // polylineLatLongs.add(LatLng(35.2297683, 33.3242372));
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
      // FlatButton(
      //     onPressed: () {
      //       showPlacePicker();
      //     },
      //     child: Text("choose place"))
    ]));
  }
}

class Hamitkoy extends StatefulWidget {
  HamitkoyState createState() => HamitkoyState();
}

class HamitkoyState extends State<Hamitkoy> {
  @override
  void onMapCreated(controller) {
    // List<LatLng> polylineLatLongs = List<LatLng>();
    // polylineLatLongs.add(LatLng(35.2297683, 33.3242372));
    // polylineLatLongs.add(LatLng(35.2081665, 33.3168829));
    // polylineLatLongs.add(LatLng(35.2080342, 33.3127617));
    // polylineLatLongs.add(LatLng(35.2083147, 33.3079388));
    // polylineLatLongs.add(LatLng(35.2094003, 33.2985768));
    // polylineLatLongs.add(LatLng(35.2092529, 33.3073316));
    // polylineLatLongs.add(LatLng(35.2122594, 33.3072266));
    // polylineLatLongs.add(LatLng(35.2183096, 33.3035460));
    // polylineLatLongs.add(LatLng(35.2217501, 33.3006690));
    // polylineLatLongs.add(LatLng(35.2145494, 33.3083649));
    // polylineLatLongs.add(LatLng(35.2124804, 33.3107219));
    // polylineLatLongs.add(LatLng(35.2103317, 33.3144706));
    // polylineLatLongs.add(LatLng(35.2096584, 33.3171102));
    // polylineLatLongs.add(LatLng(35.2297683, 33.3242372));
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
      // FlatButton(
      //     onPressed: () {
      //       showPlacePicker();
      //     },
      //     child: Text("choose place"))
    ]));
  }
}
