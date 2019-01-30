import 'package:flutter/material.dart';
import '../../../core/flutter_3d_obj/flutter_3d_obj.dart';

class ShipAttitude extends StatefulWidget {
  @override
  _ShipAttitudeState createState() => _ShipAttitudeState();
}

class _ShipAttitudeState extends State<ShipAttitude> {
  @override
  Widget build(BuildContext context) {
    return Object3D(
        size: const Size(400.0, 400.0), path: "assets/ship.obj", asset: true);
  }
}
