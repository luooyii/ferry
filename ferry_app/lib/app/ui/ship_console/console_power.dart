import 'dart:async';
import 'dart:convert';
import 'package:ferry_app/app/bloc/ship_console_bloc.dart';
import 'package:ferry_app/app/data/net/mqtt/ferry_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ShipPower extends StatefulWidget {
  ShipPower();

  @override
  _ShipPowerState createState() => _ShipPowerState();
}

class _ShipPowerState extends State<ShipPower> {
  _ShipPowerState();

  final ShipConsoleBloc shipConsoleBloc = ShipConsoleBloc.getInstance();
  final FerryMqttClient mqttClient = FerryMqttClient.getInstance();
  StreamSubscription periodicSub;
  final String topic = 'edu/just/machinelearning/test/ship';

  final List<double> currentList = [];
  final List<double> voltageList = [];
  final List<double> powerList = [];
  List<charts.Series<double, int>> seriesList;
  int i = 0;

  _subscribe() {
    var isSubscribe = false;
    periodicSub =
        Stream.periodic(const Duration(seconds: 1)).take(10).listen((_) {
      if (isSubscribe) return;
      if (mqttClient.isConnected()) {
        mqttClient.subscribeToTopic(topic);
        mqttClient.addSubscribeLisener(_onMqttMessage);
        shipConsoleBloc.showSnackBar("已订阅电力Topic");
        isSubscribe = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  void _onMqttMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    if (event[0].topic != topic) return;

    final MqttPublishMessage recMess = event[0].payload;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    var result = json.decode(message);
    debugPrint(result.toString());

    voltageList.add(result[0][0]);
    currentList.add(result[0][1]);
    powerList.add(result[0][2]);
    if (currentList.length > 11) {
      currentList.removeAt(0);
      voltageList.removeAt(0);
      powerList.removeAt(0);
    }
    i++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    seriesList = [
      new charts.Series<double, int>(
        id: 'currentChart',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (value, index) => index,
        measureFn: (value, index) => value,
        displayName: '电流',
        data: currentList,
      ),
      new charts.Series<double, int>(
        id: 'voltageChart',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (value, index) => index,
        measureFn: (value, index) => value,
        displayName: '电压',
        data: voltageList,
      ),
      new charts.Series<double, int>(
        id: 'powerChart',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (value, index) => index,
        measureFn: (value, index) => value,
        displayName: '功率',
        data: powerList,
      ),
    ];

    return new charts.LineChart(seriesList,
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: false);
  }

  @override
  void dispose() {
    mqttClient.unsubscribeFromTopic(topic);
    shipConsoleBloc.showSnackBar("取消订阅电力Topic");
    periodicSub.cancel();
    super.dispose();
  }
}
