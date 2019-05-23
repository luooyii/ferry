import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart';
import '../../../utils/ui/amap_misc.dart';
import '../../../utils/ui/amap_view.dart';

class ShipOrientation extends StatefulWidget {
  ShipOrientation();
  factory ShipOrientation.forDesignTime() => ShipOrientation();

  @override
  _ShipOrientationState createState() => _ShipOrientationState();
}

class _ShipOrientationState extends State<ShipOrientation> {
  AMapController _controller;

  var random = Random();
  int i = 0;

  _changePosition() {
    LatLng(69.608, 18.895);

    // //真实轨迹（红色实线）
    // var _realPostition = [_postion[i], _postion[i + 1]];
    // _controller.setPosition(target: _postion[i], zoom: 5);
    // _controller.addPolyline(
    //   PolylineOptions(
    //     latLngList: _realPostition,
    //     color: Colors.red[300],
    //     isGeodesic: true,
    //     lineCapType: PolylineOptions.LINE_CAP_TYPE_ROUND,
    //     width: 15,
    //   ),
    // );

    // //预测轨迹（蓝色虚线）
    // var latng = _postion[i + 2];
    // if (i == 6)
    //   _forecastPostion.add(LatLng(latng.latitude, latng.longitude));
    // else
    //   _forecastPostion.add(LatLng(latng.latitude + random.nextDouble() * 0.5,
    //       latng.longitude - random.nextDouble() * 0.5));
    // var _forePostition = [_forecastPostion[i + 1], _forecastPostion[i + 2]];
    // _controller.addPolyline(
    //   PolylineOptions(
    //     latLngList: _forePostition,
    //     color: Colors.blue,
    //     isGeodesic: true,
    //     isDottedLine: true,
    //     lineCapType: PolylineOptions.LINE_CAP_TYPE_ROUND,
    //     width: 15,
    //   ),
    // );
    // i++;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AMapView(
        onAMapViewCreated: (controller) {
          _controller = controller;
        },
        amapOptions: AMapOptions(
          mapType: MAP_TYPE_SATELLITE,
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    super.dispose();
  }
}
