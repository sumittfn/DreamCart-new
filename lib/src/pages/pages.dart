import 'package:Dreamcart/src/controllers/home_controller.dart';
import 'package:Dreamcart/src/models/cities.dart';
import 'package:Dreamcart/src/pages/settings.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../elements/DrawerWidget.dart';
import '../elements/FilterWidget.dart';
import '../models/route_argument.dart';
import '../pages/favorites.dart';
import '../pages/home.dart';
import '../pages/map.dart';
import '../pages/notifications.dart';
import '../pages/orders.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 1;
    }
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends StateMVC<PagesWidget> {
  HomeController con = HomeController();
  String city_id;
  String city;
  List<Data> cityData;
  _PagesWidgetState() : super(HomeController()) {
    con = controller;
  }

  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  void cityID(String value, String city_name) {
    // setState(() {
    city_id = value;
    city = city_name;
    // cityData = city;
    print("City ID ::::::::::::::::>>>>>>>>>>> " + value);
    print("City Name ::::::::::::::::>>>>>>>>>>> " + city_name);
    // });
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = NotificationsWidget(
            parentScaffoldKey: widget.scaffoldKey,
            cityID: city_id,
            cityName: city,
          );
          break;
//        case 1:
//          widget.currentPage = MapWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: widget.routeArgument);
//          break;
        case 1:
          widget.currentPage = HomeWidget(
            parentScaffoldKey: widget.scaffoldKey,
            cityId: cityID,
          );
          break;
        case 2:
          widget.currentPage = OrdersWidget(
            parentScaffoldKey: widget.scaffoldKey,
            city_id: city_id,
            cityName: city,
          );
          break;
        case 3:
          widget.currentPage = SettingsWidget(
            parentScaffoldKey: widget.scaffoldKey,
            cityName: city,
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return con.isCurfew == true
        ? Scaffold(
            body: DoubleBackToCloseApp(
              snackBar: SnackBar(
                content: Text("double tap to exit"),
              ),
              child: Container(
                child: Image.asset(
                  "assets/img/curfew.jpeg",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          )
        : Scaffold(
            key: widget.scaffoldKey,
            drawer: DrawerWidget(
              parentKey: widget.scaffoldKey,
            ),
            endDrawer: FilterWidget(onFilter: (filter) {
              Navigator.of(context)
                  .pushReplacementNamed('/Pages', arguments: widget.currentTab);
            }),
            body: DoubleBackToCloseApp(
              child: widget.currentPage,
              snackBar: SnackBar(
                content: Text("double tap to exit"),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).accentColor,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              iconSize: 22,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedIconTheme: IconThemeData(size: 28),
              unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
              currentIndex: widget.currentTab,
              onTap: (int i) {
                this._selectTab(i);
              },
              // this will be set when a new tab is tapped
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  title: new Container(height: 0.0),
                ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.location_on),
//              title: new Container(height: 0.0),
//            ),
                BottomNavigationBarItem(
                    title: new Container(height: 5.0),
                    icon: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.4),
                              blurRadius: 40,
                              offset: Offset(0, 15)),
                          BoxShadow(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.4),
                              blurRadius: 13,
                              offset: Offset(0, 3))
                        ],
                      ),
                      child: new Icon(Icons.home,
                          color: Theme.of(context).primaryColor),
                    )),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.fastfood),
                  title: new Container(height: 0.0),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.person),
                  title: new Container(height: 0.0),
                ),
              ],
            ),
          );
  }
}
