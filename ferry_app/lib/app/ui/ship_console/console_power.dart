import 'dart:async';
import 'dart:convert';
import 'package:ferry_app/app/data/net/mqtt/ferry_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ShipPower extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldkey;
  ShipPower(this._scaffoldkey);

  @override
  _ShipPowerState createState() => _ShipPowerState(_scaffoldkey);
}

class _ShipPowerState extends State<ShipPower> {
  final GlobalKey<ScaffoldState> _scaffoldkey;
  _ShipPowerState(this._scaffoldkey);

  FerryMqttClient mqttClient = FerryMqttClient.getInstance();
  StreamSubscription periodicSub;

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
      if (mqttClient.connectionState == MqttConnectionState.connected) {
        mqttClient.subscribeToTopic('edu/just/machinelearning/test/ship');
        mqttClient.addSubscribeLisener(_onMqttMessage);
        showSnackBar("已订阅电力Topic", 1);
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
    if (event[0].topic != 'edu/just/machinelearning/test/ship') return;

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
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (value, index) => index,
        measureFn: (value, index) => value,
        displayName: '电流',
        data: currentList,
      ),
      new charts.Series<double, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (value, index) => index,
        measureFn: (value, index) => value,
        displayName: '电压',
        data: voltageList,
      ),
      new charts.Series<double, int>(
        id: 'Mobile',
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
    mqttClient.unsubscribeFromTopic('edu/just/machinelearning/test/ship');
    showSnackBar("取消订阅电力Topic", 1);
    periodicSub.cancel();
    super.dispose();
  }

  void showSnackBar(String message, int durationSecond) {
    final snackBar = new SnackBar(
      content: new Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: Color(0x5f009688),
      duration: Duration(seconds: durationSecond), // 持续时间
    );
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }
}
