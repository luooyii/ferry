import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../bloc/biz/ship_console_bloc.dart';

class ShipPower extends StatefulWidget {
  @override
  _ShipPowerState createState() => _ShipPowerState();
}

class _ShipPowerState extends State<ShipPower> {
  final bloc = ShipConsoleBloc();

  @override
  Widget build(BuildContext context) {
    // charts.LineChart lineChart=charts.LineChart(_createSampleData());
    // lineChart.updateCommonChart(baseChart, oldWidget, chartState)

    return StreamBuilder<List>(
        stream: bloc.attitudeStream,
        initialData: bloc.lineChartData,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          return charts.LineChart(bloc.lineChartData);
        });
  }

  List<charts.Series<LinearSales, int>> _createSampleData() {
    var data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class LinearSales {
  final int year;
  final int sales;
  LinearSales(this.year, this.sales);
}
