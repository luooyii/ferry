import "package:rxdart/rxdart.dart";
import "dart:async";
import "package:common_utils/src/timer_util.dart";
import 'package:charts_common/common.dart' as common;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mqtt_client/mqtt_client.dart';
import "../../../common/uri.dart";
import '../../data/entity/chart/point.dart';

class ShipConsoleBloc {

  List<common.Series<ChartPoint, int>> lineChartData;
  final _attitudeSubject = BehaviorSubject<List>();
  Stream<List> get attitudeStream => _attitudeSubject.stream;

  Stream<Map<String, String>> credential;

  ShipConsoleBloc() {
    //connectMqttServer();

    var data = [
      new ChartPoint(0, 5),
      new ChartPoint(1, 25),
      new ChartPoint(2, 100),
      new ChartPoint(3, 75),
    ];

    lineChartData = [
      charts.Series<ChartPoint, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartPoint point, _) => point.x,
        measureFn: (ChartPoint point, _) => point.y,
        data: data,
      )
    ];

    data.add(ChartPoint(4,1000));
  }

  

  void dispose() {
    _attitudeSubject.close();
  }
}
