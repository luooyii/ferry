import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../utils/ui/amap_misc.dart';
import '../../../utils/ui/amap_view.dart';

const _postion = const [
  LatLng(69.608, 18.895),
  LatLng(67.438, 14.424),
  LatLng(65.652, 12.253),
  LatLng(64.219723, 9.380334),
  LatLng(63.013047, 6.276931),
  LatLng(61.394546, 4.123610),
  LatLng(59.353283, 4.475173),
  LatLng(57.458499, 7.320397),
  LatLng(58.021438, 10.132897),
  LatLng(55.742765, 10.725846),
];

class ShipOrientation extends StatefulWidget {
  ShipOrientation();
  factory ShipOrientation.forDesignTime() => ShipOrientation();

  @override
  _ShipOrientationState createState() => _ShipOrientationState();
}

class _ShipOrientationState extends State<ShipOrientation> {
  AMapController _controller;
  Timer timer;

  List<LatLng> _forecastPostion = [
    LatLng(70.608, 17.895),
    LatLng(67.638, 14.024),
  ];

  var random = Random();
  int i = 0;

  _changePosition() async {
    timer = new Timer(Duration(seconds: 3), () {
      setState(() {
        if (i < 8) {
          //真实轨迹（红色实线）
          var _realPostition = [_postion[i], _postion[i + 1]];
          _controller.setPosition(target: _postion[i], zoom: 5);
          _controller.addPolyline(
            PolylineOptions(
              latLngList: _realPostition,
              color: Colors.red[300],
              isGeodesic: true,
              lineCapType: PolylineOptions.LINE_CAP_TYPE_ROUND,
              width: 15,
            ),
          );

          //预测轨迹（蓝色虚线）
          var latng = _postion[i + 2];
          if (i == 6)
            _forecastPostion.add(LatLng(latng.latitude, latng.longitude));
          else
            _forecastPostion.add(LatLng(
                latng.latitude + random.nextDouble() * 0.5,
                latng.longitude - random.nextDouble() * 0.5));
          var _forePostition = [
            _forecastPostion[i + 1],
            _forecastPostion[i + 2]
          ];
          _controller.addPolyline(
            PolylineOptions(
              latLngList: _forePostition,
              color: Colors.blue,
              isGeodesic: true,
              isDottedLine: true,
              lineCapType: PolylineOptions.LINE_CAP_TYPE_ROUND,
              width: 15,
            ),
          );
          i++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _changePosition();
    return Center(
      child: AMapView(
        onAMapViewCreated: (controller) {
          _controller = controller;
        },
        amapOptions: AMapOptions(
          mapType: MAP_TYPE_SATELLITE,
          // scrollGesturesEnabled: false,
          // zoomGesturesEnabled: false,
          // tiltGesturesEnabled: false,
          // rotateGesturesEnabled: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}
