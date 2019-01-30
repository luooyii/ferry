import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart';
import '../../../utils/ui/amap_misc.dart';
import '../../../utils/ui/amap_view.dart';

const polylineList = const [
  LatLng(39.999391, 116.135972),
  LatLng(39.898323, 116.057694),
  LatLng(39.900430, 116.265061),
  LatLng(39.955192, 116.140092),
];

class ShipOrientation extends StatefulWidget {
  ShipOrientation();
  factory ShipOrientation.forDesignTime() => ShipOrientation();
  
  @override
  _ShipOrientationState createState() => _ShipOrientationState();
}

class _ShipOrientationState extends State<ShipOrientation> {
  AMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AMapView(
        onAMapViewCreated: (controller) {
          _controller = controller;
          loading(
            context,
            controller.addPolyline(
              PolylineOptions(
                latLngList: polylineList,
                color: Colors.red,
                isDottedLine: true,
                isGeodesic: true,
                dottedLineType: PolylineOptions.DOTTED_LINE_TYPE_CIRCLE,
                width: 10,
              ),
            ),
          ).catchError((e) => showError(context, e.toString()));
        },
        amapOptions: AMapOptions(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}