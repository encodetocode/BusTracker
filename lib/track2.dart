import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

Widget loadmap2(Set polyline, initialcam) {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('city')
          .doc('city_1')
          .collection('markers')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text('Loading Points');
        }

        snapshot.data.docs.forEach((change) {
          var markerIdVal = change.data()["station_name"];
          final MarkerId markerId = MarkerId(markerIdVal);

          if (change.data()['station_name'] == 'Driver 1') {
            markers[markerId] = Marker(
                markerId: markerId,
                position: LatLng(change.data()['location'].latitude,
                    change.data()['location'].longitude),
                infoWindow: InfoWindow(
                  title: change.data()['station_name'],
                ));
          } else {
            markers[markerId] = Marker(
              markerId: markerId,
              position: LatLng(change.data()['location'].latitude,
                  change.data()['location'].longitude),
              infoWindow: InfoWindow(
                title: change.data()['station_name'],
              ),
            );
          }
        });
        return GoogleMap(
          initialCameraPosition: initialcam,
          markers: Set<Marker>.of(markers.values),
          polylines: polyline,
        );
      });
}
