import 'package:flutter/material.dart';

import 'package:Dreamcart/src/models/restaurant.dart';
import 'package:Dreamcart/src/repository/restaurant_repository.dart';
import 'package:Dreamcart/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/cart.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../repository/cart_repository.dart';
import '../repository/category_repository.dart';
import '../repository/food_repository.dart';

class CategoryController extends ControllerMVC {
  List<Food> foods = <Food>[];
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Restaurant> restaurantsList = <Restaurant>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Category category;
  Restaurant restaurant;
  bool loadCart = false;
  List<Cart> carts = [];

  CategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  // void listenForFoodsByCategory({String id, String message}) async {
  //   final Stream<Food> stream = await getFoodsByCategory(id);
  //   stream.listen((Food _food) {
  //     setState(() {
  //       foods.add(_food);
  //     });
  //   }, onError: (a) {
  //     scaffoldKey.currentState.showSnackBar(SnackBar(
  //       content: Text(S.current.verify_your_internet_connection),
  //     ));
  //   }, onDone: () {
  //     if (message != null) {
  //       scaffoldKey.currentState.showSnackBar(SnackBar(
  //         content: Text(message),
  //       ));
  //     }
  //   });
  // }

   listenForStoreByCategory({String id, String message,String city_id}) async {
    final Stream<Restaurant> stream = await getStoreByCategory(id,city_id);
    stream.listen((Restaurant _restaurant) {
      setState(() {
        restaurantsList.add(_restaurant);
      });
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> listenForTopRestaurants(String city_id) async {
    final Stream<Restaurant> stream =
    await getNearRestaurants(deliveryAddress.value, deliveryAddress.value,city_id);
    stream.listen((Restaurant _restaurant) {
      setState(() => topRestaurants.add(_restaurant));
    }, onError: (a) {}, onDone: () {});
  }

//  Future<void> getRestaurantsList(String id) async {
//    final Stream<Restaurant> stream =
//    await getRestaurantList(id);
//    stream.listen((Restaurant _restaurant) {
//      setState(() => restaurantsList.add(_restaurant));
//    }, onError: (a) {}, onDone: () {});
//  }

  void listenForCategory({String id, String message}) async {
    final Stream<Category> stream = await getCategory(id);
    stream.listen((Category _category) {
      setState(() => category = _category);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
    print("Cart Data :::::::::::::::::::>>>>>>>>>>>>>>>> " + carts.toString());
  }

  // bool isSameRestaurants(Food food) {
  //   if (carts.isNotEmpty) {
  //     return carts[0].food?.restaurant?.id == food.restaurant?.id;
  //   }
  //   return true;
  // }
  //
  // /*void addToCart(Food food, {bool reset = false}) async {
  //   setState(() {
  //     this.loadCart = true;
  //   });
  //   var _cart = new Cart();
  //   _cart.food = food;
  //   _cart.extras = [];
  //   _cart.quantity = 1;
  //   addCart(_cart, reset).then((value) {
  //     setState(() {
  //       this.loadCart = false;
  //     });
  //     scaffoldKey.currentState.showSnackBar(SnackBar(
  //       content: Text('This food was added to cart'),
  //     ));
  //   });
  // }*/
  //
  // void addToCart(Food food, {bool reset = false}) async {
  //   setState(() {
  //     this.loadCart = true;
  //   });
  //   var _newCart = new Cart();
  //   _newCart.id = carts[0].id;
  //   _newCart.food = food;
  //   _newCart.extras = [];
  //   _newCart.quantity = 1;
  //   _newCart.reset = reset ? 1:0;
  //   // if food exist in the cart then increment quantity
  //   var _oldCart = isExistInCart(_newCart);
  //   if (_oldCart != null) {
  //     _oldCart.quantity++;
  //     updateCart(_oldCart).then((value) {
  //       setState(() {
  //         this.loadCart = false;
  //       });
  //     }).whenComplete(() {
  //       scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //         content: Text(S.current.this_food_was_added_to_cart),
  //       ));
  //     });
  //   } else {
  //     // the food doesnt exist in the cart add new one
  //     addCart(_newCart).then((value) {
  //       setState(() {
  //         this.loadCart = false;
  //       });
  //     }).whenComplete(() {
  //       scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //         content: Text(S.current.this_food_was_added_to_cart),
  //       ));
  //     });
  //   }
  // }
  //
  // Cart isExistInCart(Cart _cart) {
  //   return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart), orElse: () => null);
  // }

  Future<void> refreshCategory() async {
    foods.clear();
    category = new Category();
    // listenForFoodsByCategory(message: S.current.category_refreshed_successfuly);
    listenForCategory(message: S.current.category_refreshed_successfuly);
  }
}
