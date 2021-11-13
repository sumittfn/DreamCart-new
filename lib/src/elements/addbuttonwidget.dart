import 'package:Dreamcart/src/controllers/food_controller.dart';
import 'package:Dreamcart/src/models/food.dart';
import 'package:Dreamcart/src/models/route_argument.dart';
import 'package:Dreamcart/src/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'AddToCartAlertDialog.dart';

class AddButtonWidget extends StatefulWidget {
  Food food;
  AddButtonWidget({Key, key, this.food}): super (key: key);
  @override
  _AddButtonWidgetState createState() => _AddButtonWidgetState();
}

class _AddButtonWidgetState extends StateMVC<AddButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 20.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.green,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ADD",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.add,
                color: Colors.white,
                size: 10.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
