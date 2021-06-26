import 'dart:developer';
import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

const apiKey = "API-Key";

class GoogleMapsServices {
  final Set<Polyline> _polyLines = {};

  Set<Polyline> get polyLines => _polyLines;
  Set<Marker> get markers => _markers;
  final Set<Marker> _markers = {};
  final List<String> stations = [];
  String mins;
  List ways;

  Future<String> getRouteCoordinates(LatLng l1, LatLng l2,
      {List<LatLng> waypoints}) async {
    if (waypoints == null) {
      String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
      http.Response response = await http.get(url);
      Map values = jsonDecode(response.body);
      var routes = values["routes"][0];
      var timeinseconds =
          routes['legs'][0]['duration_in_traffic']['value'].toString();
      var timeinseconds2 = routes['legs'][0]['duration']['value'].toString();
      var timeinsecondsint =
          ((int.parse(timeinseconds) + int.parse(timeinseconds2)) / 60).round();
      log(timeinsecondsint.toString());
      mins = timeinsecondsint.toString();
      return values["routes"][0]["overview_polyline"]["points"];
    } else {
      var points = await getwaypoints(waypoints);
      String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&waypoints=$points&travel_mode=transit&departure_time=now&key=$apiKey";
      http.Response response = await http.get(url);
      Map values = jsonDecode(response.body);
      var routes = values["routes"];
      // log("$routes");

      // log("$legs");
      // log(values.toString());
      ways = waypoints;
      ways.add(LatLng(l1.latitude, l1.longitude));
      // var totaltime = 0;
//      for(int i = 0; i <ways.length; i++){
//        var time = routes['legs'][i]['duration']['value'].toString();
//        totaltime += int.parse(time);
//
//      }
//      totaltime = (totaltime / 60).round();
//       log(totaltime.toString());
      // var timeinseconds =
      //     routes['legs'][0]['duration_in_traffic']['value'].toString();
      // var timeinseconds2 = routes['legs'][0]['duration']['value'].toString();
      // var timeinsecondsint =
      //     ((int.parse(timeinseconds) + int.parse(timeinseconds2)) / 60).round();
      // log(timeinsecondsint.toString());
      // mins = timeinsecondsint.toString();
      // log(mins);
      return values["routes"][0]["overview_polyline"]["points"];
    }
  }

  Future<String> getDuration(LatLng l1, List<LatLng> l2) async {
    var destinations = await getwaypoints(l2);
    String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${l1.latitude},${l1.longitude}&destinations=$destinations&mode=trasit&departure_time=now&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    var tr = values.toString();
    log("$tr");
    var duration = values["rows"][0]["elements"][0]["duration"];
    return duration.toString();
  }

  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId("0"),
        width: 2,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.blue));
  }

  void createMarkers(String encondedPoly) async {
    var way = _convertToLatLng(_decodePoly(encondedPoly));
    // print(way);
    print(way.length);
    print(ways);
    for (int i = 0; i < (ways.length - 1); i++) {
      _markers.add(Marker(
          markerId: MarkerId('$i'),
          position: LatLng(ways[i].latitude, ways[i].longitude),
          onTap: () {
            Align(
                alignment: Alignment.centerLeft,
                child: FloatingActionButton(
                    child: Icon(Icons.person), onPressed: () {}));
          }));
    }
  }

  Future<String> getwaypoints(List<LatLng> way) async {
    String waypointcoords = '';
    // Future<String> finalwaypoints;
    if (way == null) {
      return null;
    } else {
      for (int i = 0; i <= (way.length - 1); i++) {
        var lat = way[i].latitude.toString();
        var lon = way[i].longitude.toString();
        if (i == 0) {
          waypointcoords += '$lat%2C$lon';
        } else {
          waypointcoords += '%7C$lat%2C$lon ';
        }
      }
      waypointcoords.trim();

      return waypointcoords;
    }
  }

  Future<String> waypoints(List<LatLng> way) async {
    String waypointcoords = '';
    if (way == null) {
      return null;
    } else {
      for (int i = 0; i <= (way.length); i++) {
        var lat = way[i].latitude.toString();
        var lon = way[i].longitude.toString();
        if (i == 0) {
          waypointcoords += '$lat%2C$lon';
        } else {
          waypointcoords += '%7C$lat%2C$lon ';
        }
      }
      waypointcoords.trim();

      return waypointcoords;
    }
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    print(lList.toString());
    return lList;
  }
}
