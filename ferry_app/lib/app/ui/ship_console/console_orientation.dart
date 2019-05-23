import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:ferry_app/app/bloc/ship_console_bloc.dart';
import 'package:ferry_app/app/data/net/mqtt/ferry_mqtt_client.dart';
import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart';
import 'package:mqtt_client/mqtt_client.dart';

class ShipOrientation extends StatefulWidget {
  ShipOrientation();
  factory ShipOrientation.forDesignTime() => ShipOrientation();

  @override
  _ShipOrientationState createState() => _ShipOrientationState();
}

class _ShipOrientationState extends State<ShipOrientation> {
  final ShipConsoleBloc shipConsoleBloc = ShipConsoleBloc.getInstance();
  final FerryMqttClient mqttClient = FerryMqttClient.getInstance();
  StreamSubscription periodicSub;
  final String topic = 'cn/luooyii/ferry/ship/position';
  
  AMapController _controller;
  LatLng originalPosition;

  var random = Random();
  int i = 0;

  _subscribe() {
    var isSubscribe = false;
    periodicSub =
        Stream.periodic(const Duration(seconds: 1)).take(10).listen((_) {
      if (isSubscribe) return;
      if (mqttClient.isConnected()) {
        mqttClient.subscribeToTopic(topic);
        mqttClient.addSubscribeLisener(_changePosition);
        shipConsoleBloc.showSnackBar("已订阅航线Topic");
        isSubscribe = true;
      }
    });
  }

  _changePosition(List<MqttReceivedMessage<MqttMessage>> event) {
    if (event[0].topic != topic) return;

    final MqttPublishMessage recMess = event[0].payload;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    var result = json.decode(message);
    debugPrint(result.toString());

    LatLng position = LatLng(result[0], result[1]);
    if (originalPosition == null) {
      originalPosition = position;
      return;
    }

    //真实轨迹（红色实线）
    var _realPostition = [originalPosition, position];
    _controller.setPosition(target: position, zoom: 5);
    _controller.addPolyline(
      PolylineOptions(
        latLngList: _realPostition,
        color: Colors.red[300],
        isGeodesic: true,
        lineCapType: PolylineOptions.LINE_CAP_TYPE_ROUND,
        width: 15,
      ),
    );
    originalPosition = position;
  }

  @override
  void initState() {
    super.initState();
    _subscribe();
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
    mqttClient.unsubscribeFromTopic(topic);
    shipConsoleBloc.showSnackBar("取消订阅航线Topic");
    periodicSub.cancel();
    if (_controller != null) _controller.dispose();
    super.dispose();
  }
}
