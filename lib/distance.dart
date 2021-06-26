import 'dart:convert';
import 'dart:async' show Future;
import 'package:busmap/functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const apiKey = "AIzaSyAB85B9V9XjstZ9_BT_GF70Jb6AitZvseM";
GoogleMapsServices mapservice = GoogleMapsServices();

class DistanceMatrix {
  final List<String> destinations;
  final List<String> origins;
  final List<Element> elements;
  final String status;

  DistanceMatrix({this.destinations, this.origins, this.elements, this.status});

  factory DistanceMatrix.fromJson(Map<String, dynamic> json) {
    var destinationsJson = json['destination_addresses'];
    var originsJson = json['origin_addresses'];
    var rowsJson = json['rows'][0]['elements'] as List;

    return DistanceMatrix(
        destinations: destinationsJson.cast<String>(),
        origins: originsJson.cast<String>(),
        elements: rowsJson.map((i) => new Element.fromJson(i)).toList(),
        status: json['status']);
  }

  static Future<DistanceMatrix> loadData(LatLng l1, List<LatLng> l2) async {
    var destinations = await mapservice.getwaypoints(l2);
    DistanceMatrix distanceMatrix;
    try {
      String url =
          "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${l1.latitude},${l1.longitude}&destinations=$destinations&mode=trasit&departure_time=now&key=$apiKey";
      http.Response jsonData = await http.get(url);
      distanceMatrix = new DistanceMatrix.fromJson(jsonDecode(jsonData.body));
    } catch (e) {
      print(e);
    }
    return distanceMatrix;
  }
}

class Element {
  final Distance distance;
  final Duration duration;
  final DurationTraffic duration_traffic;
  final String status;

  Element({this.distance, this.duration, this.duration_traffic, this.status});

  factory Element.fromJson(Map<String, dynamic> json) {
    return Element(
        distance: new Distance.fromJson(json['distance']),
        duration: new Duration.fromJson(json['duration']),
        duration_traffic:
            new DurationTraffic.fromJson(json['duration_in_traffic']),
        status: json['status']);
  }
}

class Distance {
  final String text;
  final int value;

  Distance({this.text, this.value});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return new Distance(text: json['text'], value: json['value']);
  }
}

class Duration {
  final String text;
  final int value;

  Duration({this.text, this.value});

  factory Duration.fromJson(Map<String, dynamic> json) {
    return new Duration(text: json['text'], value: json['value']);
  }
}

class DurationTraffic {
  final String text;
  final int value;

  DurationTraffic({this.text, this.value});

  factory DurationTraffic.fromJson(Map<String, dynamic> json) {
    return new DurationTraffic(text: json['text'], value: json['value']);
  }
}
