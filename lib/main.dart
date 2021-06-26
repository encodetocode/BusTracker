import 'dart:developer';

import 'package:busmap/authentication_services.dart';
import 'package:busmap/driver_login.dart';
import 'package:busmap/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'driver_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationServices>(
            create: (_) => AuthenticationServices(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) =>
                context.read<AuthenticationServices>().authStateChanges,
          )
        ],
        child: MaterialApp(
            theme: ThemeData(
              fontFamily: 'Robo',
            ),
            title: 'Flutter Google Maps Demo',
            initialRoute: "/",
            routes: {
              "/": (context) => MapSample(),
              '/homepage': (context) => MyHomePage(),
              '/driverlogin': (context) => Driver_LogIn(),
              '/driverpage': (context) => DriverPage(),
            }));
  }
}

class MapSample extends StatelessWidget {
  const MapSample({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return DriverPage();
    }
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
                            builder: (context) => Driver_LogIn(),
                            fullscreenDialog: true));
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
  }
}
