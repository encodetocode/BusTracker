import 'package:busmap/authentication_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Driver_LogIn extends StatefulWidget {
  Driver_LogInState createState() => Driver_LogInState();
}

class Driver_LogInState extends State<Driver_LogIn> {
  final TextEditingController emailcontrol = TextEditingController();
  final TextEditingController passwordcontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    // final firebaseUser = context.watch<User>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Driver LogIn'),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(children: [
                    TextFormField(
                      controller: emailcontrol,
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
                      controller: passwordcontrol,
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
                          onPressed: () async {
                            try {
                              await context
                                  .read<AuthenticationServices>()
                                  .signIn(
                                      email: emailcontrol.text,
                                      password: passwordcontrol.text);
                            } catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text(
                                          "The password or Email doesnt match"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }
                            // if (firebaseUser != null) {
                            //   Navigator.pop(context);
                            // }
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )),
                  ]),
                ))));
  }
}
