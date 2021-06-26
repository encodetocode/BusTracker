import 'package:busmap/cities/hamitkoy.dart';
import 'package:busmap/cities/lefkosa.dart';
import 'package:busmap/cities/yenikent.dart';
import 'package:busmap/tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';

class MyHomePage extends StatefulWidget {
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // @override
  // Widget build(BuildContext context) {
  // return DefaultTabController(
  //   length: 4,
  //   child: MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(
  //         bottom: TabBar(
  //           physics: NeverScrollableScrollPhysics(),
  //           onTap: (index) {
  //             // Tab index when user select it, it start from zero
  //           },
  //           tabs: [
  //             Tab(
  //                 text: "Gonyeli",
  //                 icon: Icon(
  //                   Icons.directions_bus,
  //                   color: Colors.red,
  //                 )),
  //             Tab(
  //                 text: "Lefkosa",
  //                 icon: Icon(
  //                   Icons.directions_bus,
  //                   color: Colors.green,
  //                 )),
  //             Tab(
  //                 text: "Yenikent",
  //                 icon: Icon(
  //                   Icons.directions_bus,
  //                   color: Colors.white,
  //                 )),
  //             Tab(
  //               text: "Hamitkoy",
  //               icon: Icon(
  //                 Icons.directions_bus,
  //                 color: Colors.yellow,
  //               ),
  //               // child: Text("Hamitkoy", style: TextStyle(fontSize: 12))
  //             ),
  //           ],
  //         ),
  //         title: Text('Tabs Demo'),
  //       ),
  //       body: TabBarView(
  //         physics: NeverScrollableScrollPhysics(),
  //         children: [
  //           Container(
  //             child: Gonyeli(),
  //           ),
  //           Center(
  //               child: Text(
  //             "1",
  //             style: TextStyle(fontSize: 40),
  //           )),
  //           Center(
  //               child: Text(
  //             "0",
  //             style: TextStyle(fontSize: 40),
  //           )),
  //           Center(
  //               child: Text(
  //             "1",
  //             style: TextStyle(fontSize: 40),
  //           )),
  //         ],
  //       ),
  //     ),
  //   ),
  // );
  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  int _currentIndex = 0;
  final List<Widget> _pages = [Gonyeli(), Lefkosa(), Yenikent(), Hamitkoy()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backdrop Demo',
      home: BackdropScaffold(
        appBar: BackdropAppBar(
          title: Text("Map"),
          actions: <Widget>[
            // BackdropToggleButton(
            //   icon: AnimatedIcons.list_view,
            // )
          ],
        ),
        stickyFrontLayer: true,
        frontLayer: _pages[_currentIndex],
        backLayer: BackdropNavigationBackLayer(
          items: [
            ListTile(
                leading: Icon(Icons.directions_bus), title: Text("Gonyeli")),
            ListTile(
                leading: Icon(Icons.directions_bus), title: Text("Lefkosa")),
            ListTile(
                leading: Icon(Icons.directions_bus), title: Text("Yenikent")),
            ListTile(
                leading: Icon(Icons.directions_bus), title: Text("Hamitkoy")),
          ],
          onTap: (int position) => {setState(() => _currentIndex = position)},
        ),
      ),
    );
  }
}
