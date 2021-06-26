import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Widget loadmap(Set polyline, CameraPosition initialcam) {
  Set<Marker> allmarkers = HashSet<Marker>();
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('city')
          .doc('city_1')
          .collection('markers')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("loading");
        print(snapshot.data.docs.length);
        for (int i = 0; i < snapshot.data.docs.length; i++) {
          var es = snapshot.data.docs[i]["location"].latitude;
          log("$es");
          allmarkers.add(new Marker(
              markerId: MarkerId(snapshot.data.docs[i]["station_name"]),
              position: LatLng(snapshot.data.docs[i]["location"].latitude,
                  snapshot.data.docs[i]["location"].longitude),
              infoWindow:
                  InfoWindow(title: snapshot.data.docs[i]["station_name"])));
        }
        ;
        log("$allmarkers");
        return GoogleMap(
          initialCameraPosition: initialcam,
          markers: allmarkers,
          polylines: polyline,
        );
      });
}
