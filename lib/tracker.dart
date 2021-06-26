import 'dart:async';
import 'dart:developer';

import 'package:busmap/display_tracker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tracker {
  Geolocator geolocator = Geolocator();
  StreamSubscription _subscription;
  StreamSubscription<Position> location;
  CollectionReference users = FirebaseFirestore.instance
      .collection('city')
      .doc('city_1')
      .collection('user');
  DisplayOnmap display = DisplayOnmap();
  Future<Position> getlocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position mylocation;

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

    location = Geolocator.getPositionStream().listen((position) {
      log("getting location....");
      log("$position");
      CollectionReference users = FirebaseFirestore.instance
          .collection('city')
          .doc('city_1')
          .collection('markers');
      mylocation = position;
      print("this is mylocation $mylocation");
      return users
          .doc('driver_01')
          .update({'location': GeoPoint(position.latitude, position.longitude)})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    });

    display.updatemarkeronmap(mylocation);
    return mylocation;
  }

  void dispose() {
    location.pause();
  }
}
