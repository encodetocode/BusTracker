import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DisplayOnmap {
  Set<Marker> streammarkers;
  Future<void> updatemarkeronmap(Position loc) async {
    log("recieved the location : $loc");
    CollectionReference users = FirebaseFirestore.instance
        .collection('city')
        .doc('city_1')
        .collection('markers');

    await users
        .doc('driver_01')
        .update({'location': GeoPoint(loc.latitude, loc.longitude)})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<Set> retrivemarkers() async {
    CollectionReference mark = FirebaseFirestore.instance
        .collection('city')
        .doc('city_1')
        .collection('markers');
    StreamBuilder<QuerySnapshot>(
        stream: mark.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            log('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            log("Loading");
          }

          snapshot.data.docs.map((DocumentSnapshot document) {
            var station = document['station_name'];
            log("$document");
            streammarkers.add(Marker(
                position: LatLng(document['location'].latitude,
                    document['location'].longitude),
                draggable: false,
                infoWindow: InfoWindow(title: document['station_name']),
                markerId: MarkerId('$station')));
            // initMarker(snapshot.data);
          });
          return Text("done");
        });
    return streammarkers;
  }
}

// initMarker(client) {
//   // _markers.then(val){
//   print("$client");
//   var station = client['station_name'];
//   streammarkers.add(Marker(
//       position:
//           LatLng(client['location'].latitude, client['location'].longitude),
//       draggable: false,
//       infoWindow: InfoWindow(title: client['station_name']),
//       markerId: MarkerId('$station')));
//   // };
// }
