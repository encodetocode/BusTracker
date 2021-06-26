// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';
//
// class Track {
//   Location location;
//   CollectionReference users = FirebaseFirestore.instance
//       .collection('city')
//       .doc('city_1')
//       .collection('user');
//
//   void toggleListening() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//     // LocationData _locationData;
//
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     location.onLocationChanged.listen((LocationData currentLocation) {
//       // Use current location
//       users
//           .doc('user_01')
//           .update({
//             'location':
//                 GeoPoint(currentLocation.latitude, currentLocation.longitude)
//           })
//           .then((value) => print("User Updated"))
//           .catchError((error) => print("Failed to update user: $error"));
//     });
//   }
// }
