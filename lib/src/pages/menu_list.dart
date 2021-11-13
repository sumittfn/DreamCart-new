import 'package:Dreamcart/src/elements/RestaurantwiseCategoriesWidget.dart';
import 'package:Dreamcart/src/elements/ShoppingCartFloatButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../elements/FoodsCarouselWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;

  MenuWidget({Key key, this.routeArgument}) : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  RestaurantController _con;

  _MenuWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {

    print("City Name Data ::::::::::::::>>>>>>>> " + widget.routeArgument.city);
    print("Restaurant ID :- " + widget.routeArgument.id);
    // _con.listenForCart();
    _con.categoriesByRestaurant(widget.routeArgument.id);
    // _con.listenForTrendingFoods(widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(
        city_id: widget.routeArgument.city_id,
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _con.foods.isNotEmpty ? _con.foods[0].restaurant.name : '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          _con.loadCart
              ? SizedBox(
                  width: 60,
                  height: 60,
                  child: RefreshProgressIndicator(),
                )
              : new ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).hintColor,
                  labelColor: Theme.of(context).accentColor,
                  food: _con.food,
                  param: '/Menu',
                  id: widget.routeArgument.id,
                  city_id: widget.routeArgument.city_id,
            city: widget.routeArgument.city
                )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(city_id: widget.routeArgument.city_id,city_name: widget.routeArgument.city,),
            ),
            ListTile(
              dense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.list,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).product_category,
                style: Theme.of(context).textTheme.display1,
              ),

            ),
            RestaurantwiseCategoriesWidget(
              restaurant_id: widget.routeArgument.id,
              city_id: widget.routeArgument.city_id,
              categories: _con.categoryList,
city: widget.routeArgument.city,
            ),

          ],
        ),
      ),
    );
  }
}
