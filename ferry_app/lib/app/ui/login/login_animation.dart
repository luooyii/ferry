import 'package:ferry_app/app/ui/index/index.dart';
import 'package:flutter/material.dart';
import '../../../common/theme.dart';
import 'dart:async';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.buttonController})
      : buttonSqueezeanimation = new Tween(
          begin: 320.0,
          end: 70.0,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.5,
            ),
          ),
        ),
        containerCircleAnimation = new EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: new InkWell(
          onTap: () {
            //_playAnimation();
          },
          child: new Hero(
            tag: "fade",
            child: new Container(
                width: buttonSqueezeanimation.value,
                height: 60.0,
                alignment: FractionalOffset.center,
                decoration: new BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(30.0)),
                ),
                child: buttonSqueezeanimation.value > 75.0
                    ? new Text(
                        "登录",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.3,
                        ),
                      )
                    : new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 1.0,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      )),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}

class JumpAnimation extends StatelessWidget {
  JumpAnimation({Key key, this.successController})
      : buttomZoomOut = new Tween(
          begin: 70.0,
          end: 1000.0,
        ).animate(
          new CurvedAnimation(
            parent: successController,
            curve: Curves.bounceOut,
          ),
        ),
        super(key: key);

  final AnimationController successController;
  final Animation buttomZoomOut;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: new InkWell(
          child: new Hero(
        tag: "fade",
        child: new Container(
            width: buttomZoomOut.value,
            height: buttomZoomOut.value,
            alignment: FractionalOffset.center,
            decoration: new BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: buttomZoomOut.value < 400
                  ? new BorderRadius.all(const Radius.circular(30.0))
                  : new BorderRadius.all(const Radius.circular(0.0)),
            ),
            child: buttomZoomOut.value < 300.0
                ? new CircularProgressIndicator(
                    value: null,
                    strokeWidth: 1.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : null),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: successController,
    );
  }
}
