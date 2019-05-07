import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'styles.dart';
import 'login_animation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import '../../widget/signup_link.dart';
import '../../widget/button/signin_button.dart';
import '../../widget/form/form.dart';
import '../index/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;
  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(seconds: 30), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text('Are you sure?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/home"),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    _addControllerListener();
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          body: new Container(
              decoration: new BoxDecoration(
                image: backgroundImage,
              ),
              child: new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                    colors: <Color>[
                      const Color.fromRGBO(162, 146, 199, 0.8),
                      const Color.fromRGBO(51, 51, 63, 0.9),
                    ],
                    stops: [0.2, 1.0],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                  )),
                  child: new ListView(
                    padding: const EdgeInsets.all(0.0),
                    children: <Widget>[
                      new Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Container(
                                  padding: EdgeInsets.fromLTRB(0, 70, 0, 70),
                                  child: new Text("Ferry",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 95))),
                              new FormContainer(),
                              new SignUp()
                            ],
                          ),
                          animationStatus == 0
                              ? new Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: new InkWell(
                                      onTap: () {
                                        setState(() {
                                          animationStatus = 1;
                                        });
                                        _playAnimation();
                                      },
                                      child: new SignIn()),
                                )
                              : new StaggerAnimation(
                                  buttonController:
                                      _loginButtonController.view),
                        ],
                      ),
                    ],
                  ))),
        )));
  }

  void showSnackBar(String message) {
    final snackBar = new SnackBar(
      content: new Text(message),
      backgroundColor: Color(0xffc91b3a),
      duration: Duration(seconds: 3), // 持续时间
      //animation,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _addControllerListener() {
    _loginButtonController.addListener(() {
      if (_loginButtonController.isCompleted) {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext) {
          return Index();
        }));
        //Navigator.pushNamed(context, "/home");
      }
    });
  }

  void getHttp() async {
    try {
      Response response;
      var data = {'username': 'luooyii', 'password': 'luooyii'};
      response = await Dio()
          .get("http://132.232.22.168:8080/ferry/users", queryParameters: data);


      showSnackBar(response.toString());
      return print(response);
    } catch (e) {
      return print(e);
    }
  }
}
