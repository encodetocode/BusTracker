import 'dart:developer';

import 'package:busmap/authentication_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

TextEditingController location = TextEditingController();

class DriverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Driver"),
          centerTitle: true,
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(location.text),
          ),
          Padding(
              padding: EdgeInsets.all(5),
              child: FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
                splashColor: Colors.blueAccent,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)),
                onPressed: () async {
                  Position position = await _determinePosition();
                  location.text = position.toString();
                },
                child: Text(
                  "Track me",
                  style: TextStyle(fontSize: 20.0),
                ),
              )),
          Padding(
              padding: EdgeInsets.all(5),
              child: FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
                splashColor: Colors.blueAccent,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)),
                onPressed: () {
                  context.read<AuthenticationServices>().signOut();
                },
                child: Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 20.0),
                ),
              )),
        ])));
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

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
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition();
}
