import 'package:flutter/material.dart';
import '../../common/constants/color.dart';
import 'console_attitude.dart';
import 'console_orientation.dart';
import 'console_power.dart';

class ShipConsole extends StatefulWidget {
  @override
  _ShipConsoleState createState() => _ShipConsoleState();
}

class _ShipConsoleState extends State<ShipConsole> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: new AppBar(
            title: Text("barSearch"),
            bottom: new TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black12,
              tabs: [
                new Tab(text: "动力"),
                new Tab(text: "方位"),
                new Tab(text: "姿态"),
              ],
            ),
          ),
          body: new TabBarView(
              children: [
                ShipPower(),
                ShipOrientation(),
                ShipAttitude()
              ]
          ),
        ),
    );
  }
}
