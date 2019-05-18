import 'package:flutter/material.dart';
import 'input_fields.dart';

class FormContainer extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  FormContainer({this.usernameController, this.passwordController});

  @override
  Widget build(BuildContext context) {
    return (Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InputFieldArea(
                hint: "用户名",
                obscure: false,
                icon: Icons.person_outline,
                controller: usernameController,
              ),
              InputFieldArea(
                hint: "密码",
                obscure: true,
                icon: Icons.lock_outline,
                controller: passwordController,
              ),
            ],
          )),
        ],
      ),
    ));
  }
}
