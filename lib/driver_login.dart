import 'package:flutter/material.dart';

class Driver_LogIn extends StatefulWidget {
  Driver_LogInState createState() => Driver_LogInState();
}

class Driver_LogInState extends State<Driver_LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Driver LogIn'),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(children: [
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      contentPadding: EdgeInsets.all(15),
                      labelText: 'Driver_ID'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key),
                      contentPadding: EdgeInsets.all(15),
                      labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
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
                      onPressed: () {},
                      child: Text(
                        "Log In",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    )),
              ]),
            )));
  }
}