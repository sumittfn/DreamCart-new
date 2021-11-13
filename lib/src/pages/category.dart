import 'package:flutter/material.dart';
import 'package:Dreamcart/src/elements/CardWidget.dart';
import 'package:Dreamcart/src/elements/categorycardwidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/category_controller.dart';
import '../elements/AddToCartAlertDialog.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FilterWidget.dart';
import '../elements/FoodGridItemWidget.dart';
import '../elements/FoodListItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class CategoryWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CategoryWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends StateMVC<CategoryWidget> {
  // TODO add layout in configuration file
  String layout = 'grid';

  CategoryController _con;

  _CategoryWidgetState() : super(CategoryController()) {
    _con = controller;
  }

  @override
  void initState() {

    print("City Nname :::::::::>>>>>>>>>>> " + widget.routeArgument.city);
    print("City ID :::::::::::::::::::::::::::::>>>>>>>>>>>>>>>>>>" +
                widget.routeArgument.city_id ==
            null
        ? ""
        : widget.routeArgument.city_id.toString());
//    _con.listenForFoodsByCategory(id: widget.routeArgument.id);
    _con.listenForStoreByCategory(
        id: widget.routeArgument.id, city_id: widget.routeArgument.city_id);
    _con.listenForTopRestaurants(widget.routeArgument.city_id);
    _con.listenForCategory(id: widget.routeArgument.id);
    _con.listenForCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Restaurant List :-" + _con.restaurantsList.length.toString());
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(
        city_id: widget.routeArgument.city_id,
        city: widget.routeArgument.city,
      ),
      endDrawer: FilterWidget(onFilter: (filter) {
        Navigator.of(context).pushReplacementNamed('/Category',
            arguments: RouteArgument(id: widget.routeArgument.id));
      }),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).category,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          _con.loadCart
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.5, vertical: 15),
                  child: SizedBox(
                    width: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).hintColor,
                  labelColor: Theme.of(context).accentColor,
                  param: "/Category",
                  city_id: widget.routeArgument.city_id,
                  cityData: widget.routeArgument.cityData,
                  city: widget.routeArgument.city,
                ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshCategory,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(onClickFilter: (filter) {
                  _con.scaffoldKey.currentState.openEndDrawer();
                },city_id: widget.routeArgument.city_id,city_name: widget.routeArgument.city,),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.category,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    _con.category?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ),
              _con.restaurantsList == null
                  ? Center(
                      child: Center(
                        child: Text(
                          "No Store found",
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height - 200.0,
                      child: _con.restaurantsList.length != 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _con.restaurantsList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      '/Details',
                                      arguments: new RouteArgument(
                                          id: _con.restaurantsList
                                              .elementAt(index)
                                              .id,
                                          city_id: widget.routeArgument.city_id,
                                          city: widget.routeArgument.city
                                          // heroTag: ''
                                          ),
                                    );
                                  },
                                  child: CategoryCardWidget(
                                    restaurant:
                                        _con.restaurantsList.elementAt(index),
                                    heroTag: 'home_restaurants',
                                  ),
                                );
                              },
                            )
                          : CircularLoadingWidget(
                              height: 500,
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
