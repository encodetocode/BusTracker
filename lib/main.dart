import 'package:busmap/driver_login.dart';
import 'package:busmap/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Robo',
        ),
        title: 'Flutter Google Maps Demo',
        initialRoute: "/",
        routes: {
          "/": (context) => MapSample(),
          '/homepage': (context) => MyHomePage(),
        });
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // Completer<GoogleMapController> _controller = Completer();
  // MyAppBar tab;

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome to Bus Tracker"),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(5),
                child: FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.fromLTRB(57, 8, 57, 8),
                  splashColor: Colors.blueAccent,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Driver_LogIn()));
                  },
                  child: Text(
                    "Driver",
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: Text(
                    "Student",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ))
          ],
        )));
    // Future<void> _goToTheLake() async {
    //   final GoogleMapController controller = await _controller.future;
    //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
