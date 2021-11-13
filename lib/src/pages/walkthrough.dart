import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/walkthrough_controller.dart';

class Walkthrough extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new WalkthroughWidget(),
    );
  }
}

class WalkthroughWidget extends StatefulWidget {
  WalkthroughWidget({
    Key key,
  }) : super(key: key);

  @override
  _WalkthroughWidgetState createState() => _WalkthroughWidgetState();
}

class _WalkthroughWidgetState extends StateMVC<WalkthroughWidget> {
  WalkthroughController _con;

  _WalkthroughWidgetState() : super(WalkthroughController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
