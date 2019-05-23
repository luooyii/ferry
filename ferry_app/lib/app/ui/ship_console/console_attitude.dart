import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ferry_app/app/bloc/ship_console_bloc.dart';
import 'package:ferry_app/app/data/net/mqtt/ferry_mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' show Vector3;
import 'package:vector_math/vector_math.dart' as V;

class ShipAttitude extends StatefulWidget {
  final Size size = Size(400.0, 400.0);
  final String path = "assets/ship.obj";
  final double zoom = 0.05;

  @override
  _ShipAttitudeState createState() => _ShipAttitudeState();
}

class _ShipAttitudeState extends State<ShipAttitude> {
  final ShipConsoleBloc shipConsoleBloc = ShipConsoleBloc.getInstance();
  final FerryMqttClient mqttClient = FerryMqttClient.getInstance();
  StreamSubscription periodicSub;
  final String topic = '/just/adxl345/angel';

  _subscribe() {
    var isSubscribe = false;
    periodicSub =
        Stream.periodic(const Duration(seconds: 1)).take(10).listen((_) {
      if (isSubscribe) return;
      if (mqttClient.isConnected()) {
        mqttClient.subscribeToTopic(topic);
        mqttClient.addSubscribeLisener(_changePosition);
        shipConsoleBloc.showSnackBar("已订阅姿态Topic");
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

    setState(() {
      xAxis = double.parse(result[0]);
      yAxis = double.parse(result[1]);
      zAxis = double.parse(result[2]);
      angleX = _previousX + xAxis;
      angleY = _previousY + yAxis;
    });
  }

  @override
  void initState() {
    super.initState();
    _subscribe();

    rootBundle.loadString(widget.path).then((String value) {
      setState(() {
        object = value;
      });
    });
  }

  @override
  void dispose() {
    mqttClient.unsubscribeFromTopic(topic);
    shipConsoleBloc.showSnackBar("取消订阅姿态Topic");
    periodicSub.cancel();
    super.dispose();
  }

  //bool useInternal;

  double xAxis = 0.0;
  double yAxis = 0.0;
  double zAxis = 0.0;

  double angleX = 80.1630859375;
  double angleY = 37.806640625;
  double angleZ = 0.0;

  final double _previousX = 80.1630859375;
  final double _previousY = 37.806640625;

  double zoom;
  String object = "V 1 1 1 1";

  File file;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomPaint(
          painter: new _ObjectPainter(
              widget.size, object, angleX, angleY, angleZ, widget.zoom),
          size: widget.size,
        ),
        Text('X轴 ${xAxis}', style: TextStyle(fontSize: 18)),
        Text('Y轴 ${yAxis}', style: TextStyle(fontSize: 18)),
        Text('Z轴 ${zAxis}', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}

class _ObjectPainter extends CustomPainter {
  //缩放因子
  double _zoomFactor = 10.0;

  //  final double _rotation = 5.0; // in degrees
  double _translation = 0.1 / 100;
  //  final double _scalingFactor = 10.0 / 100.0; // in percent

  final double zero = 0.0;

  final String object;

  double _viewPortX = 0.0, _viewPortY = 0.0;

  List<Vector3> vertices;
  List<dynamic> faces;
  V.Matrix4 T;
  Vector3 camera;
  Vector3 light;

  double angleX;
  double angleY;
  double angleZ;

  Color color;

  Size size;

  _ObjectPainter(this.size, this.object, this.angleX, this.angleY, this.angleZ,
      this._zoomFactor) {
    _translation *= _zoomFactor;
    camera = new Vector3(0.0, 0.0, 0.0);
    light = new Vector3(0.0, 0.0, 100.0);
    color = new Color.fromARGB(255, 255, 255, 255);
    _viewPortX = (size.width / 2).toDouble();
    _viewPortY = (size.height / 2).toDouble();
  }

  //解析obj
  Map _parseObjString(String objString) {
    List vertices = <Vector3>[];
    List faces = <List<int>>[];
    List<int> face = [];

    List lines = objString.split("\n");

    Vector3 vertex;

    lines.forEach((dynamic line) {
      String lline = line;
      lline = lline.replaceAll(new RegExp(r"\s+$"), "");
      List<String> chars = lline.split(" ");

      // vertex
      if (chars[0] == "v") {
        vertex = new Vector3(double.parse(chars[1]), double.parse(chars[2]),
            double.parse(chars[3]));

        vertices.add(vertex);

        // face
      } else if (chars[0] == "f") {
        for (var i = 1; i < chars.length; i++) {
          face.add(int.parse(chars[i].split("/")[0]));
        }

        faces.add(face);
        face = [];
      }
    });

    return {'vertices': vertices, 'faces': faces};
  }

  bool _shouldDrawFace(List face) {
    var normalVector = _normalVector3(
        vertices[face[0] - 1], vertices[face[1] - 1], vertices[face[2] - 1]);

    var dotProduct = normalVector.dot(camera);
    double vectorLengths = normalVector.length * camera.length;

    double angleBetween = dotProduct / vectorLengths;

    return angleBetween < 0;
  }

  Vector3 _normalVector3(Vector3 first, Vector3 second, Vector3 third) {
    Vector3 secondFirst = new Vector3.copy(second);
    secondFirst.sub(first);
    Vector3 secondThird = new Vector3.copy(second);
    secondThird.sub(third);

    return new Vector3(
        (secondFirst.y * secondThird.z) - (secondFirst.z * secondThird.y),
        (secondFirst.z * secondThird.x) - (secondFirst.x * secondThird.z),
        (secondFirst.x * secondThird.y) - (secondFirst.y * secondThird.x));
  }

  double _scalarMultiplication(Vector3 first, Vector3 second) {
    return (first.x * second.x) + (first.y * second.y) + (first.z * second.z);
  }

  Vector3 _calcDefaultVertex(Vector3 vertex) {
    T = new V.Matrix4.translationValues(_viewPortX, _viewPortY, zero);
    T.scale(_zoomFactor, -_zoomFactor);

    T.rotateX(_degreeToRadian(angleX != null ? angleX : 0.0));
    T.rotateY(_degreeToRadian(angleY != null ? angleY : 0.0));
    T.rotateZ(_degreeToRadian(angleZ != null ? angleZ : 0.0));

    return T.transform3(vertex);
  }

  double _degreeToRadian(double degree) {
    return degree * (Math.pi / 180.0);
  }

  List<dynamic> _drawFace(List<Vector3> verticesToDraw, List face) {
    List<dynamic> list = <dynamic>[];
    Paint paint = new Paint();
    Vector3 normalizedLight = new Vector3.copy(light).normalized();

    var normalVector = _normalVector3(verticesToDraw[face[0] - 1],
        verticesToDraw[face[1] - 1], verticesToDraw[face[2] - 1]);

    Vector3 jnv = new Vector3.copy(normalVector).normalized();

    double koef = _scalarMultiplication(jnv, normalizedLight);

    if (koef < 0.0) {
      koef = 0.0;
    }

    Color newColor = new Color.fromARGB(255, 0, 0, 0);

    Path path = new Path();

    newColor = newColor.withRed((color.red.toDouble() * koef).round());
    newColor = newColor.withGreen((color.green.toDouble() * koef).round());
    newColor = newColor.withBlue((color.blue.toDouble() * koef).round());
    paint.color = newColor;
    paint.style = PaintingStyle.fill;

    bool lastPoint = false;
    double firstVertexX, firstVertexY, secondVertexX, secondVertexY;

    for (int i = 0; i < face.length; i++) {
      if (i + 1 == face.length) {
        lastPoint = true;
      }

      if (lastPoint) {
        firstVertexX = verticesToDraw[face[i] - 1][0].toDouble();
        firstVertexY = verticesToDraw[face[i] - 1][1].toDouble();
        secondVertexX = verticesToDraw[face[0] - 1][0].toDouble();
        secondVertexY = verticesToDraw[face[0] - 1][1].toDouble();
      } else {
        firstVertexX = verticesToDraw[face[i] - 1][0].toDouble();
        firstVertexY = verticesToDraw[face[i] - 1][1].toDouble();
        secondVertexX = verticesToDraw[face[i + 1] - 1][0].toDouble();
        secondVertexY = verticesToDraw[face[i + 1] - 1][1].toDouble();
      }

      if (i == 0) {
        path.moveTo(firstVertexX, firstVertexY);
      }

      path.lineTo(secondVertexX, secondVertexY);
    }
    var z = 0.0;
    face.forEach((dynamic x) {
      int xx = x;
      z += verticesToDraw[xx - 1].z;
    });

    path.close();
    list.add(path);
    list.add(paint);
    return list;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Map parsedFile = _parseObjString(object);
    vertices = parsedFile["vertices"];
    faces = parsedFile["faces"];

    List<Vector3> verticesToDraw = [];
    vertices.forEach((vertex) {
      verticesToDraw.add(new Vector3.copy(vertex));
    });

    for (int i = 0; i < verticesToDraw.length; i++) {
      verticesToDraw[i] = _calcDefaultVertex(verticesToDraw[i]);
    }

    final List<Map> avgOfZ = List();
    for (int i = 0; i < faces.length; i++) {
      List face = faces[i];
      double z = 0.0;
      face.forEach((dynamic x) {
        int xx = x;
        z += verticesToDraw[xx - 1].z;
      });
      Map data = <String, dynamic>{
        "index": i,
        "z": z,
      };
      avgOfZ.add(data);
    }
    avgOfZ.sort((Map a, Map b) => a['z'].compareTo(b['z']));

    for (int i = 0; i < faces.length; i++) {
      List face = faces[avgOfZ[i]["index"]];
      if (_shouldDrawFace(face) || true) {
        final List<dynamic> faceProp = _drawFace(verticesToDraw, face);
        canvas.drawPath(faceProp[0], faceProp[1]);
      }
    }
  }

  @override
  bool shouldRepaint(_ObjectPainter old) =>
      old.object != object ||
      old.angleX != angleX ||
      old.angleY != angleY ||
      old.angleZ != angleZ ||
      old._zoomFactor != _zoomFactor;
}
