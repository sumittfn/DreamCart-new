import 'package:Dreamcart/src/controllers/food_controller.dart';
import 'package:Dreamcart/src/controllers/restaurant_controller.dart';
import 'package:Dreamcart/src/elements/AddToCartAlertDialog.dart';
import 'package:Dreamcart/src/models/cart.dart';
import 'package:Dreamcart/src/repository/user_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/food.dart';
import '../models/route_argument.dart';
import 'addbuttonwidget.dart';

class FoodItemWidget extends StatefulWidget {
  final String heroTag;
  final Food food;
  RestaurantController con;
  List<Cart> carts;
  final String city;
  String city_id;

  FoodItemWidget(
      {Key key,
      this.food,
      this.heroTag,
      this.city,
      this.carts,
      this.con,
      this.city_id})
      : super(key: key);

  @override
  _FoodItemWidgetState createState() => _FoodItemWidgetState();
}

class _FoodItemWidgetState extends State<FoodItemWidget> {
  // void initState(){
  // }
  @override
  void initState(){
    print("City ID >>>>: "+ widget.city_id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Food',
            arguments: RouteArgument(
                id: widget.food.id,
                heroTag: this.widget.heroTag,
                city: widget.city,
                city_id: widget.city_id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            widget.food.veg == "0"
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      "assets/img/veg.png",
                      width: 12.0,
                      height: 12.0,
                    ),
                  )
                : Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      "assets/img/nonveg.png",
                      width: 12.0,
                      height: 12.0,
                    ),
                  ),
            SizedBox(width: 5),
            Hero(
              tag: widget.heroTag + widget.food.id,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Image.network(
                  widget.food.image.thumb,
                  loadingBuilder: (context, child, loadingProgress) =>
                      (loadingProgress == null)
                          ? child
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.food.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Text(
                          widget.food.restaurant.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Helper.getPrice(widget.food.price, context,
                          style: Theme.of(context).textTheme.display1),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                            onTap: () {
                              // con.food = food;
                              if (currentUser.value.apiToken == null) {
                                Navigator.of(context).pushNamed("/Login");
                              } else {
                                setState(() {});
                                if (widget.con.isSameRestaurants(widget.food)) {
                                  widget.con.addToCart(widget.food);
                                } else {
                                  // print("Old Food ::::::::::::>>>>>>>>>>> " +
                                  //     widget.con.carts.elementAt(0).food.name);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AddToCartAlertDialogWidget(
                                          oldFood: widget.con.carts
                                              .elementAt(0)
                                              .food,
                                          newFood: widget.food,
                                          onPressed: (food, {reset: true}) {
                                            return widget.con
                                                .addToCart(food, reset: true);
                                          });
                                    },
                                  );
                                }
                              }
                            },
                            child: AddButtonWidget(
                              food: widget.food,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
