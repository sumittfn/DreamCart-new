import 'package:Dreamcart/src/models/cart.dart';
import 'package:Dreamcart/src/models/category.dart';
import 'package:Dreamcart/src/models/favorite.dart';
import 'package:Dreamcart/src/models/user.dart';
import 'package:Dreamcart/src/repository/cart_repository.dart';
import 'package:Dreamcart/src/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart' as userRepo;
import '../../generated/i18n.dart';
import '../models/food.dart';
import '../models/gallery.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../repository/food_repository.dart';
import '../repository/gallery_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';

class RestaurantController extends ControllerMVC {
  Restaurant restaurant;
  List<Gallery> galleries = <Gallery>[];
  List<Food> foods = <Food>[];
  List<Food> trendingFoods = <Food>[];
  List<Food> featuredFoods = <Food>[];
  List<Review> reviews = <Review>[];
  List<Category> categoryList = <Category>[];
  Food food;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = <Cart>[];
  Favorite favorite;
  bool loadCart = false;
  GlobalKey<ScaffoldState> scaffoldKey;

  RestaurantController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForRestaurant({String id, String message}) async {
    final Stream<Restaurant> stream =
        await getRestaurant(id, deliveryAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => restaurant = _restaurant);
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

  void listenForGalleries(String idRestaurant) async {
    final Stream<Gallery> stream = await getGalleries(idRestaurant);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForRestaurantReviews({String id, String message}) async {
    final Stream<Review> stream = await getRestaurantReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForFoods(String idRestaurant, String category_id) async {
    final Stream<Food> stream =
        await getFoodsOfRestaurant(idRestaurant, category_id);
    stream.listen((Food _food) {
      setState(() => foods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () async {

  await    listenForCart();
    });
  }

  void listenForTrendingFoods(String idRestaurant) async {
    final Stream<Food> stream =
        await getTrendingFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedFoods(String idRestaurant) async {
    final Stream<Food> stream =
        await getFeaturedFoodsOfRestaurant(idRestaurant);
    stream.listen((Food _food) {
      setState(() => featuredFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

 Future<void> listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    }, onDone: () {
      print("Cart Details ::::::::::::::::::>>>>>>>>>>> " + carts.toString());
    }, onError: (e) {
      print("Error Errror ::::::::::::><><>><><>><><><><>" + e.toString());
    });
  }

  bool isSameRestaurants(Food food) {
    if (carts.isNotEmpty) {

      print("Old Restaurant ID ::::::::::::>>>>>" + carts[0].food?.restaurant?.id.toString());
      print("New Restaurant Id :::::::::::::>> " + food.restaurant?.id);
      return carts[0].food?.restaurant?.id == food.restaurant?.id;
    }
    return true;
  }

  void addToCart(Food food, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    print("Food Details ::::::::::::::::::>>>>>>>>>>>>>>>>>> " + food.id);
    User _user = userRepo.currentUser.value;
    if (_user.apiToken == null) {
      new Cart();
    }
    var _newCart = new Cart();
    _newCart.food = food;
    _newCart.extras = food.extras.where((element) => element.checked).toList();
    _newCart.quantity = this.quantity;
    _newCart.reset = reset ? 1 : 0;
    _newCart.api_token = _user.apiToken;
    _newCart.userId = _user.id;
    // if food exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity += this.quantity;
      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
          // return carts.add(value);
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
          print("Data Cart Value" + value.toMap().toString());
        });
      }).whenComplete(() async {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.current.this_food_was_added_to_cart),
        ));
      });
    }
  }

  void categoriesByRestaurant(String id) async {
    final Stream<Category> category = await getCategoriesByRestaurant(id);

    category.listen((Category categories) {
      setState(() {});
      categoryList.add(categories);
      print("Category Data List :::::::::::::::::::::>>>>>>>>>>>>>>>>>>>>>" +
          categories.name.toString());
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void enquryNow(
      {String restaurant_id,
      String description,
      String username,
      String mobile,
      String user_id}) async {
    print("Description::::::::::::::::>>>>>>>>>>>>>> " + description);
    await addEnquiry(
        username: username,
        description: description,
        mobile: mobile,
        restaurant_id: restaurant_id,
        user_id: user_id);
  }

  Cart isExistInCart(Cart _cart) {
    // listenForCart();
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  Future<void> refreshRestaurant() async {
    print("Restaurant ID ::::::::::::>>>>>> " + restaurant.id);
    var _id = restaurant.id;
    carts = <Cart>[];
    restaurant = new Restaurant();
    galleries.clear();
    reviews.clear();
    featuredFoods.clear();
    listenForRestaurant(
        id: _id, message: S.current.restaurant_refreshed_successfuly);
    listenForRestaurantReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedFoods(_id);
    listenForCart();
  }
}
