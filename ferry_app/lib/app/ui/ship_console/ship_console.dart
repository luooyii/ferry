import 'package:ferry_app/app/data/entity/sys_user.dart';
import 'package:ferry_app/app/data/net/mqtt/ferry_mqtt_client.dart';
import 'package:ferry_app/app/widget/console_drawer.dart';
import 'package:flutter/material.dart';
import '../../../common/color.dart';
import '../../../common/theme.dart';
import 'console_attitude.dart';
import 'console_orientation.dart';
import 'console_power.dart';

class ShipConsole extends StatefulWidget {
  final SysUser sysUser;
  ShipConsole(this.sysUser);

  @override
  _ShipConsoleState createState() => _ShipConsoleState(sysUser);
}

class _ShipConsoleState extends State<ShipConsole> {
  FerryMqttClient mqttClient = FerryMqttClient.getInstance();
  final SysUser sysUser;

  _ShipConsoleState(this.sysUser);

  @override
  void initState() {
    super.initState();
    mqttClient.connect();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(
          title: Text('监视器'),
          backgroundColor: AppTheme.primaryColor,
          bottom: new TabBar(
            indicatorColor: Colors.white, //Color(AppColors.PrimaryColor),
            labelColor: Colors.white, //Color(AppColors.PrimaryColor),
            unselectedLabelColor: Colors.black12,
            tabs: [
              new Tab(text: "动力"),
              new Tab(text: "方位"),
              new Tab(text: "姿态"),
            ],
          ),
        ),
        drawer: ConsoleDrawer(sysUser),
        body: new TabBarView(
            children: [ShipPower(), ShipOrientation(), ShipAttitude()]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
