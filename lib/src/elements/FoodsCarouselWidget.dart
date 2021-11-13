import 'package:Dreamcart/src/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import '../elements/FoodsCarouselItemWidget.dart';
import '../elements/FoodsCarouselLoaderWidget.dart';
import '../models/food.dart';

class FoodsCarouselWidget extends StatelessWidget {
  final List<Food> foodsList;
  final String heroTag;
  HomeController con;

  FoodsCarouselWidget({Key key, this.foodsList, this.heroTag, this.con}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Food List ::::::_ " + foodsList.toString());
    return foodsList.isEmpty
        ? FoodsCarouselLoaderWidget()
        : Container(
            height: 220,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              itemCount: foodsList.length,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return FoodsCarouselItemWidget(
                  heroTag: heroTag,
                  marginLeft: _marginLeft,
                  food: foodsList.elementAt(index),
                  con: con,
                );
              },
              scrollDirection: Axis.horizontal,
            ));
  }
}
