import 'package:Dreamcart/generated/i18n.dart';
import 'package:Dreamcart/src/models/banner.dart';
import 'package:Dreamcart/src/models/cart.dart';
import 'package:Dreamcart/src/models/cities.dart';
import 'package:Dreamcart/src/models/favorite.dart';
import 'package:Dreamcart/src/models/gallery.dart';
import 'package:Dreamcart/src/pages/home.dart';
import 'package:Dreamcart/src/repository/cart_repository.dart';
import 'package:Dreamcart/src/repository/gallery_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../repository/category_repository.dart';
import '../repository/food_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';

class HomeController extends ControllerMVC {
  List<Category> categories = <Category>[];
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Restaurant> popularRestaurants = <Restaurant>[];
  List<Review> recentReviews = <Review>[];
  List<DriverReview> recentDriverReview = <DriverReview>[];
  List<Food> trendingFoods = <Food>[];
  List<Data> cityData = <Data>[];
  String city_id;
  String city_name;
  DateTime fromDate;
  DateTime toDate;
  Food food;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  Favorite favorite;
  bool loadCart = false;
  GlobalKey<ScaffoldState> scaffoldKey;
  BannerList galleries;
  bool isCurfew = false;
  DateFormat dateFormat = new DateFormat.Hm();
  HomeController() {
    selectCity();
    listenForBanners();
    // listenForTrendingFoods();
    listenForCategories();

    // listenForRecentReviews();
  }
  bool serviceStatus(String city_id) {
    for (int i = 0; i < cityData.length; i++) {
      if (city_id == cityData[i].id.toString()) {
        setState((){});
        if (cityData[i].type == "1") {
          DateTime now = DateTime.now();
          now = DateTime.parse(now.toString());
          fromDate = dateFormat.parse(cityData[i].fromTime);
          fromDate = DateTime(now.year, now.month, now.day, fromDate.hour,
              fromDate.minute);
          toDate = dateFormat.parse(cityData[i].toTime);
          toDate = DateTime(now.year, now.month, now.day, toDate.hour,
              toDate.minute);
          // isCurrentDateInRange(fromDate,toDate);
          print("From date :::>>>>>" + fromDate.toString());
          print("To date :::>>>>>" + toDate.toString());
          if (now.isAfter(fromDate) && now.isBefore(toDate)) {
            return isCurfew = true;
          } else {
            isCurfew = false;
          }
        } else {
          cityData[i].type = "0";
          return isCurfew = false;
        }
      }
    }
  }

  bool isCurrentDateInRange(DateTime startDate, DateTime endDate) {
    DateTime currentDate = DateTime.now();
    currentDate = DateTime.parse(currentDate.toString());
    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  }

  void selectCity() async {
    final Stream<Data> stream = await getCitiesList();
    stream.listen((Data city) {
      setState(() => cityData.add(city));
    }, onError: (a) {
      print("Error" + a.toString());
    }, onDone: () {
      print("City ID :::::::::::>>>>>>>"+ city_id);
      serviceStatus(city_id);
      listenForPopularRestaurants(city_id: city_id);
      // listenForBanners();
    });
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForTopRestaurants(String city_id) async {
    final Stream<Restaurant> stream = await getNearRestaurants(
        deliveryAddress.value, deliveryAddress.value, city_id);
    stream.listen((Restaurant _restaurant) {
      setState(() => topRestaurants.add(_restaurant));
    }, onError: (a) {
      print("Api Error");
    }, onDone: () {
      print("Api Success");
    });
  }

  Future<void> listenForPopularRestaurants({String city_id}) async {
    final Stream<Restaurant> stream =
        await getPopularRestaurants(deliveryAddress.value, city_id);
    stream.listen((Restaurant _restaurant) {
      setState(() => popularRestaurants.add(_restaurant));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForBanners() async {
    final Stream<BannerList> stream = await getBanners();
    stream.listen((BannerList _gallery) {
      print("Banner Data List ::::::::>>>>>" + _gallery.toString());
      setState(() => galleries = _gallery);
    }, onError: (a) {
      print("Error Banner :::>" + a.toString());
    }, onDone: () {
      print("Banner Data List ::::::::>>>>>" + galleries.toString());
    });
  }

  Future<void> listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForDriverRecentReviews() async {
    final Stream<DriverReview> stream = await getDriverReviews();
    stream.listen((DriverReview _review) {
      setState(() => recentDriverReview.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForTrendingFoods({String city_id}) async {
    final Stream<Food> stream =
        await getTrendingFoods(deliveryAddress.value, city_id);
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void requestForCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }

  bool isSameRestaurants(Food food) {
    if (carts.isNotEmpty) {
      return carts[0].food?.restaurant?.id == food.restaurant?.id;
    }
    return true;
  }

  void addToCart(Food food, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart = new Cart();
    _newCart.food = food;
    _newCart.extras = food.extras.where((element) => element.checked).toList();
    _newCart.quantity = this.quantity;
    _newCart.reset = reset ? 1 : 0;
    // if food exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity += this.quantity;
      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.current.this_food_was_added_to_cart),
        ));
      });
    } else {
      // the food doesnt exist in the cart add new one
      addCart(_newCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.current.this_food_was_added_to_cart),
        ));
      });
    }
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  Future<void> refreshHome({String id, String cityName}) async {
    setState(() {
      categories = <Category>[];
      topRestaurants = <Restaurant>[];
      popularRestaurants = <Restaurant>[];
      recentReviews = <Review>[];
      trendingFoods = <Food>[];
      cityData = <Data>[];
      city_id = id;
      city_name = cityName;
      galleries = BannerList();
      refresh();
    });
     selectCity();
    await serviceStatus(city_id);
    await listenForBanners();
    // await listenForTopRestaurants(id);
    await listenForTrendingFoods(city_id: id);
    await listenForCategories();
    await listenForPopularRestaurants(city_id: id);
    await listenForRecentReviews();
  }
}
