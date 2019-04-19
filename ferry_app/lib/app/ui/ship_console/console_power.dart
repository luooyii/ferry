import 'dart:async';
import 'package:flutter/material.dart';
import 'simple.dart';

class ShipPower extends StatefulWidget {
  @override
  _ShipPowerState createState() => _ShipPowerState();
}

class _ShipPowerState extends State<ShipPower> {
  Timer timer;

  _changePosition() async {
    timer = Timer(Duration(seconds: 3), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleLineChart.withRandomData();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
