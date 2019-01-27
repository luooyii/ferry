import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../../common/config/global_config.dart';

class ShipMonitor extends StatefulWidget {
  @override
  _ShipMonitorState createState() => _ShipMonitorState();
}

class _ShipMonitorState extends State<ShipMonitor> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('船舶监控'),
          ),
          body: new Center(child: null),
        ),
        theme: GlobalConfig.themeData);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
