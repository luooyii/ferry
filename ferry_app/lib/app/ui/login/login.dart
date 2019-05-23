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
  AnimationController _loginSuccessController;
  var animationStatus = 0;
  final _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
      duration: new Duration(seconds: 1),
      vsync: this,
    );
    _loginSuccessController = new AnimationController(
      duration: new Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    _loginSuccessController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
    } on TickerCanceled {}
  }

  int _lastClickTime = 0;
  Future<bool> _onWillPop() {
    showSnackBar("再按一次返回键退出Ferry", 2);

    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      //退出
      return new Future.value(true);
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      return new Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          key: _scaffoldkey,
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
                              new FormContainer(
                                usernameController: _usernameController,
                                passwordController: _passwordController,
                              ),
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
                                        _loginSync();
                                      },
                                      child: new SignIn()),
                                )
                              : animationStatus == 1
                                  ? StaggerAnimation(
                                      buttonController:
                                          _loginButtonController.view,
                                    )
                                  : JumpAnimation(
                                      successController:
                                          _loginSuccessController,
                                    ),
                        ],
                      ),
                    ],
                  ))),
        )));
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

  var username;
  var password;

  void _loginSync() async {
    try {
      Response response;
      var data = {
        'username': _usernameController.text,
        'password': _passwordController.text
      };
      response = await Dio()
          .get("http://132.232.22.168:8080/ferry/users", queryParameters: data);

      print(response);
      if (response.data['status'] == "200") {
        if (response.data['data'] != null) {
          if (_loginButtonController.isCompleted) {
            setState(() {
              animationStatus = 2;
            });
          } else {
            _loginButtonController.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                setState(() {
                  animationStatus = 2;
                });
              }
            });
          }

          _loginSuccessController.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return Index(response.data['data']);
              }), (route) => route == null);
            }
          });

          _loginSuccessController.forward();
          return;
        } else {
          showSnackBar(response.data['message'], 3);
        }
      } else {
        showSnackBar("未知错误", 3);
      }

      if (_loginButtonController.isCompleted) {
        _loginButtonController.reverse();
        setState(() {
          animationStatus = 0;
        });
      } else {
        _loginButtonController.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _loginButtonController.reverse();
            setState(() {
              animationStatus = 0;
            });
          }
        });
      }

      // if (response.data['status'] == 200) {
      //   if (response.data.data != null) {
      //     Navigator.pushNamed(context, "/ship/console");
      //   } else {
      //     showSnackBar("密码错误", 3);
      //   }
      // } else if (response.data['status'] == 204) {
      //   showSnackBar("用户不存在", 3);
      // } else {
      //   showSnackBar("未知错误", 3);
      // }
    } catch (e) {
      print(e);
    }
  }
}
