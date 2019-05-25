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

  final List<double> currentList = [], voltageList = [], powerList = [];
  double current = 0.0, voltage = 0.0, power = 0.0;
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

    setState(() {
      voltage = result[0][0];
      voltageList.add(voltage);
      current = result[0][1];
      currentList.add(current);
      power = result[0][2];
      powerList.add(power);

      if (currentList.length > 11) {
        currentList.removeAt(0);
        voltageList.removeAt(0);
        powerList.removeAt(0);
      }
      i++;
    });
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

    return Column(
      children: <Widget>[
        Container(
          height: 420,
          child: charts.LineChart(seriesList, animate: true),
        ),
        new SizedBox(
          height: 15,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text('电流 ${current}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.blue)),
              flex: 1,
            ),
            Expanded(
              child: Text('电压 ${voltage}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              flex: 1,
            ),
            Expanded(
              child: Text('功率 ${power}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.green)),
              flex: 1,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    mqttClient.unsubscribeFromTopic(topic);
    shipConsoleBloc.showSnackBar("取消订阅电力Topic");
    periodicSub.cancel();
    super.dispose();
  }
}
