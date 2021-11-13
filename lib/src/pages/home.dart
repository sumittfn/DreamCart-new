import 'package:Dreamcart/src/elements/CircularLoadingWidget.dart';
import 'package:Dreamcart/src/elements/citybottommodelsheet.dart';
import 'package:Dreamcart/src/models/category.dart';
import 'package:Dreamcart/src/models/cities.dart';
import 'package:Dreamcart/src/models/food.dart';
import 'package:Dreamcart/src/models/restaurant.dart';
import 'package:Dreamcart/src/models/review.dart';
import 'package:Dreamcart/src/models/route_argument.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
// import 'package:in_app_update/in_app_update.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_version/new_version.dart';
import '../../generated/i18n.dart';
import '../controllers/home_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CaregoriesCarouselWidget.dart';
import '../elements/DeliveryAddressBottomSheetWidget.dart';
import '../elements/FoodsCarouselWidget.dart';
import '../elements/GridWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  Function cityId;

  HomeWidget({
    Key key,
    this.parentScaffoldKey,
    this.cityId,
  }) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  // AppUpdateInfo _updateInfo;
  bool _flexibleUpdateAvailable = false;
  HomeController _con;
  String cityName;
  String city_id;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }
  void initState() {
    cityName = "Khamgaon";
    city_id = "13";
    _con.city_id = "13";
    widget.cityId("13", "Kahamgaon");
    _checkVersion();

    // _con.listenForCategories();
    // _con.listenForPopularRestaurants(city_id: "13");
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      context: context,
      androidId: "com.portalperfect.dreamcart",
    );

    newVersion.showAlertIfNecessary();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // print("bANNER gALLARIES :::::::>>>>>>>>>" + _con.galleries.data.toList().toString());

    return Scaffold(
        key: _scaffoldKey,
        appBar: _con.isCurfew == true
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                title: InkWell(
                  onTap: () {
                    _setRoleBottomSheet();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: double.infinity,
                      height: 30.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  cityName,
                                  style: TextStyle(fontSize: 14.0),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            size: 15.0,
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black26)),
                    ),
                  ),
                ),
              )
            : AppBar(
                leading: new IconButton(
                  icon:
                      new Icon(Icons.sort, color: Theme.of(context).hintColor),
                  onPressed: () =>
                      widget.parentScaffoldKey.currentState.openDrawer(),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: ValueListenableBuilder(
                  valueListenable: settingsRepo.setting,
                  builder: (context, value, child) {
                    return Text(
                      value.appName ?? S.of(context).home,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .merge(TextStyle(letterSpacing: 1.3)),
                    );
                  },
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
                          param: '/Pages',
                          id: '2',
                          food: _con.food,
                          city_id: city_id,
                          cityData: _con.cityData,
                          city: cityName,
                        ),
                ],
              ),
        body: _con.isCurfew == true
            ? Container(
                child: Image.asset(
                  "assets/img/curfew.jpeg",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              )
            : RefreshIndicator(
                onRefresh: _con.refreshHome,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SearchBarWidget(
                          onClickFilter: (event) {
                            widget.parentScaffoldKey.currentState
                                .openEndDrawer();
                          },city_id: city_id,
                          city_name: cityName,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      InkWell(
                        onTap: () {
                          _setRoleBottomSheet();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            width: double.infinity,
                            height: 35.0,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        cityName,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                Icon(
                                  Icons.arrow_drop_down_sharp,
                                  size: 15.0,
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.black26)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "Latest Offers",
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Center(
                        child: Container(
                            margin: const EdgeInsets.all(10.0),
                            child: _con.galleries == null
                                ? CircularProgressIndicator()
                                : CarouselSlider(
                                    items: allBanners(),
                                    options: CarouselOptions(
                                        // aspectRatio: 3,

enlargeCenterPage: true,

                                        pageSnapping: true,
                                        height: 130.0,
                                        reverse: true,viewportFraction: 1.0,
                                        scrollDirection: Axis.horizontal,
                                        autoPlayInterval:
                                            Duration(seconds: 6),
                                        // autoPlayAnimationDuration:
                                        //     Duration(seconds: 10),
                                        autoPlay: true),
                                  )),
                      ), //container
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.category,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            S.of(context).category,
                            style: Theme.of(context).textTheme.display1,
                          ),
                        ),
                      ),
                      CategoriesCarouselWidget(
                        categories: _con.categories,
                        city_id: _con.city_id,
                        cityData: _con.cityData,
                        city: cityName,
                      ),
                      // ListTile(
                      //   dense: true,
                      //   contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      //   leading: Icon(
                      //     Icons.trending_up,
                      //     color: Theme.of(context).hintColor,
                      //   ),
                      //   title: Text(
                      //     S.of(context).trending_this_week,
                      //     style: Theme.of(context).textTheme.display1,
                      //   ),
                      //   subtitle: Text(
                      //     S.of(context).double_click_on_the_food_to_add_it_to_the,
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .caption
                      //         .merge(TextStyle(fontSize: 11)),
                      //   ),
                      // ),
                      // FoodsCarouselWidget(
                      //   foodsList: _con.trendingFoods,
                      //   heroTag: 'home_food_carousel',
                      //   con: _con,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.trending_up,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            S.of(context).most_popular,
                            style: Theme.of(context).textTheme.display1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridWidget(
                          restaurantsList: _con.popularRestaurants,
                          heroTag: 'home_restaurants',
                          cityName: cityName,
                          city_id: city_id,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "Upcoming Offers",
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                      Center(
                        child: Container(
                            margin: const EdgeInsets.all(10.0),
                            child: _con.galleries == null
                                ? RefreshProgressIndicator()
                                : CarouselSlider(
                                    items: allUpcomming(),
                                    options: CarouselOptions(
                                        // aspectRatio: 5,
                                      pageSnapping: true,
                                        enlargeCenterPage: true,
                                        height: 130.0,
                                        reverse: true,
                                        scrollDirection: Axis.horizontal,
                                        viewportFraction: 1.0,
                                        autoPlayInterval:
                                            Duration(seconds: 6),
                                        // autoPlayAnimationDuration:
                                        //     Duration(seconds: 10),
                                        autoPlay: true),
                                  )),
                      ),
                    ],
                  ),
                ),
              ));
  }

  void _setRoleBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 200.0,
              child: ModalBottomSheet(
                city: _con.cityData,
                setCompany: selectedCity,
              ),
            ),
          );
        });
  }

  void selectedCity(Data city) {
    setState(() {});
    cityName = city.name;
    city_id = city.id.toString();

    _con.refreshHome(cityName: city.name, id: city.id.toString());
    widget.cityId(city.id.toString(), city.name);
    // _con.serviceStatus(city.id.toString());
  }

  List<Widget> allBanners() {
    List<Widget> bannerList = [];
    // print("Gallaries Banner ::::::::::::::>>>>>> " + _con.galleries.data.toList().toString());
    if (_con.galleries.data == null) {
      bannerList.add(Container(
        width: 50.0,
        height: 50.0,
        // color: Colors.red,
        child: CircularLoadingWidget(
          height: 50.0,
        ),
      ));
    } else {
      for (int i = 0; i < _con.galleries.data.length; i++) {
        if (_con.galleries.data[i].hasMedia == false) {
          null;
        } else {
          for (int j = 0; j < _con.galleries.data[i].media.length; j++) {
            _con.galleries.data[i].offer == "1"
                ? bannerList.add(
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: InkWell(
                        onTap: () {
                          if (_con.galleries.data[i].productId == null) {
                            Navigator.of(context).pushNamed(
                              '/Details',
                              arguments: new RouteArgument(
                                  id: _con.galleries.data[i].restaurantId
                                      .toString(),
                                  city: cityName,
                                  city_id: city_id
                                  // heroTag: ''
                                  ),
                            );
                          } else {
                            // if(_con.galleries.data[i].productId != null) {
                              Navigator.of(context).pushNamed(
                                '/Food',
                                arguments: new RouteArgument(

                                    id: _con.galleries.data[i].productId
                                        .toString(),
                                    city: cityName,
                                    city_id: city_id
                                  // heroTag: ''
                                ),
                              );
                            // }
                          }
                        },
                        child: FittedBox(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Image.network(
                              _con.galleries.data[i].media[j].url.toString(),
                              // height: 200.0,
                              // // MediaQuery.of(context).size.height > 800.0
                              // //     ? 178.5
                              //      80.0,
                              // width: 800.0,
                              // fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(); //ClipRect);
          }
        }
      }
    }
    return bannerList;
  }

  List<Widget> allUpcomming() {
    List<Widget> bannerList = [];
    if (_con.galleries.data == null) {
      bannerList.add(Container(
        width: 50.0,
        height: 50.0,
        child: CircularLoadingWidget(
          height: 50.0,
        ),
      ));
    } else {
      for (int i = 0; i < _con.galleries.data.length; i++) {
        if (_con.galleries.data[i].hasMedia == false) {
          null;
        } else {
          for (int j = 0; j < _con.galleries.data[i].media.length; j++) {
            _con.galleries.data[i].offer == "0"
                ? bannerList.add(
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: InkWell(
                        onTap: () {
                          if (_con.galleries.data[i].restaurantId != null) {
                            Navigator.of(context).pushNamed(
                              '/Details',
                              arguments: new RouteArgument(
                                  id: _con.galleries.data[i].restaurantId
                                      .toString(),
                                  city: cityName,
                                  city_id: city_id
                                  // heroTag: ''
                                  ),
                            );
                          } else {
                            Navigator.of(context).pushNamed(
                              '/Product',
                              arguments: new RouteArgument(
                                  id: _con.galleries.data[i].restaurantId
                                      .toString(),
                                  city: cityName,
                                  city_id: city_id
                                  // heroTag: ''
                                  ),
                            );
                          }
                        },
                        child: FittedBox(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Image.network(
                              _con.galleries.data[i].media[j].url.toString(),
                              // height: 200.0,
                              // // MediaQuery.of(context).size.height > 800.0
                              // //     ? 178.5
                              //      80.0,
                              // width: 800.0,
                              // fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(); //ClipRect);
          }
        }
      }
    }
    return bannerList;
  }
}
