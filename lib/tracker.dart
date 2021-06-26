import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'functions.dart';
import 'distance.dart';

class Tracker {
  GoogleMapsServices mapservices = GoogleMapsServices();
  Geolocator geolocator = Geolocator();
  StreamSubscription _subscription;
  StreamSubscription<Position> location;
  List<String> duration;
  bool tracking = false;
  CollectionReference users = FirebaseFirestore.instance
      .collection('city')
      .doc('city_1')
      .collection('user');

  DistanceMatrix dismat;
  Future<Position> getlocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position mylocation;

    CollectionReference users = FirebaseFirestore.instance
        .collection('city')
        .doc('city_1')
        .collection('markers');

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location pemissions are denied (actual value: $permission).');
      }
    }

    location = Geolocator.getPositionStream().listen((position) async {
      log("getting location....");
      log("$position");
      mylocation = position;

      return users
          .doc('driver_01')
          .update({'location': GeoPoint(position.latitude, position.longitude)})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    });

    return mylocation;
  }

  void dispose() {
    location.pause();
  }
}
