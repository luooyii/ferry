import 'package:flutter/material.dart';
import '../../../common/color.dart';
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
            indicatorColor: Color(AppColors.PrimaryColor),
            labelColor: Color(AppColors.PrimaryColor),
            unselectedLabelColor: Colors.black12,
            tabs: [
              new Tab(text: "动力"),
              new Tab(text: "方位"),
              new Tab(text: "姿态"),
            ],
          ),
        ),
        drawer: new Drawer(),
        body: new TabBarView(
            children: [ShipPower(), ShipOrientation(), ShipAttitude()]),
      ),
    );
  }
}
