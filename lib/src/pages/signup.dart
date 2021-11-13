import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController _con;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  ScrollController scrollController;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: config.App(context).appWidth(100),
              height: config.App(context).appHeight(29.5),
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(29.5) - 120,
            child: Container(
              width: config.App(context).appWidth(84),
              height: config.App(context).appHeight(29.5),
              child: Text(
                S.of(context).lets_start_with_register,
                style: Theme.of(context)
                    .textTheme
                    .display3
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: CustomScrollView(
              // reverse: true,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(
                  child: Wrap(
                    runSpacing: 8.0,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: config.App(context).appHeight(29.5) - 50,
                            bottom: 10.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 50,
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.2),
                                )
                              ]),
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 50, horizontal: 27),
                          width: config.App(context).appWidth(88),
                          height: config.App(context).appHeight(85),
                          child: Form(
                            key: _con.loginFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  onSaved: (input) => _con.user.name = input,
                                  validator: (input) => input.length < 3
                                      ? S
                                          .of(context)
                                          .should_be_more_than_3_letters
                                      : null,
                                  focusNode: _nodeText1,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).full_name,
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: S.of(context).john_doe,
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.person_outline,
                                        color: Theme.of(context).accentColor),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.2))),
                                  ),
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (input) => _con.user.email = input,
                                  validator: (input) => !input.contains('@')
                                      ? S.of(context).should_be_a_valid_email
                                      : null,
                                  focusNode: _nodeText2,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).email,
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: 'johndoe@gmail.com',
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.alternate_email,
                                        color: Theme.of(context).accentColor),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.2))),
                                  ),
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  onSaved: (input) {
                                    _con.user.phone = input;
                                    _con.user.mobile = input;
                                  },
                                  validator: (input) => input.length > 10
                                      ? S
                                          .of(context)
                                          .mobile_no_should_be_10_digit
                                      : null,
                                  focusNode: _nodeText3,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).mobile_no,
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: S.of(context).number_hint,
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.call,
                                        color: Theme.of(context).accentColor),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.2))),
                                  ),
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                  obscureText: _con.hidePassword,
                                  onSaved: (input) =>
                                      _con.user.password = input,
                                  validator: (input) => input.length < 6
                                      ? S
                                          .of(context)
                                          .should_be_more_than_6_letters
                                      : null,
                                  focusNode: _nodeText4,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).password,
                                    labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: '••••••••••••',
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.7)),
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: Theme.of(context).accentColor),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _con.hidePassword =
                                              !_con.hidePassword;
                                        });
                                      },
                                      color: Theme.of(context).focusColor,
                                      icon: Icon(_con.hidePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.2))),
                                  ),
                                ),
                                SizedBox(height: 30),
                                BlockButtonWidget(
                                  text: Text(
                                    S.of(context).register,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    _con.register();
                                  },
                                ),
                                SizedBox(height: 25),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('/Login');
                                  },
                                  textColor: Theme.of(context).hintColor,
                                  child: Text(S
                                      .of(context)
                                      .i_have_account_back_to_login),
                                )
//                      FlatButton(
//                        onPressed: () {
//                          Navigator.of(context).pushNamed('/MobileVerification');
//                        },
//                        padding: EdgeInsets.symmetric(vertical: 14),
//                        color: Theme.of(context).accentColor.withOpacity(0.1),
//                        shape: StadiumBorder(),
//                        child: Text(
//                          'Register with Google',
//                          textAlign: TextAlign.start,
//                          style: TextStyle(
//                            color: Theme.of(context).accentColor,
//                          ),
//                        ),
//                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
