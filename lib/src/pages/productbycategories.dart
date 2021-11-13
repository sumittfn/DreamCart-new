import 'package:Dreamcart/generated/i18n.dart';
import 'package:Dreamcart/src/controllers/restaurant_controller.dart';
import 'package:Dreamcart/src/elements/CircularLoadingWidget.dart';
import 'package:Dreamcart/src/elements/DrawerWidget.dart';
import 'package:Dreamcart/src/elements/FoodItemWidget.dart';
import 'package:Dreamcart/src/elements/SearchBarWidget.dart';
import 'package:Dreamcart/src/elements/ShoppingCartButtonWidget.dart';
import 'package:Dreamcart/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ProductByCategories extends StatefulWidget {
  final RouteArgument routeArgument;

  const ProductByCategories({Key key, this.routeArgument}) : super(key: key);

  @override
  _ProductByCategoriesState createState() => _ProductByCategoriesState();
}

class _ProductByCategoriesState extends StateMVC<ProductByCategories> {
  RestaurantController _con;

  _ProductByCategoriesState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    print("Restaurant ID :- " + widget.routeArgument.id);
    print("City ID :- " + widget.routeArgument.city_id);
    print("Category ID :- " + widget.routeArgument.category_id);
    print("City Name :- " + widget.routeArgument.city);

    _con.listenForFoods(
        widget.routeArgument.id, widget.routeArgument.category_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
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
                  param: '/Product',
                  id: widget.routeArgument.id,
                  city_id: widget.routeArgument.city_id,
                  category_id: widget.routeArgument.category_id,
                  city: widget.routeArgument.city,
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
            _con.foods.isEmpty
                ? CircularLoadingWidget(height: 250)
                : _con.food == []
                    ? Center(child: Text("No product found"))
                    : ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.foods.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return FoodItemWidget(
                            heroTag: 'menu_list',
                            food: _con.foods.elementAt(index),
                            con: _con,
                            carts: _con.carts,
                            city_id: widget.routeArgument.city_id,
                            city: widget.routeArgument.city,
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
