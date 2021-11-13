import 'package:Dreamcart/src/models/coupon.dart';
import 'package:Dreamcart/src/repository/coupon_repository.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/cart.dart';
import '../repository/cart_repository.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  double discount = 0.0;
  double outof = 0.0;
  String city_id;
  String restaurant_id;
  GlobalKey<ScaffoldState> scaffoldKey;
  Coupon coupon = new Coupon.fromJSON({});
  bool showCode = false;
  String discountType;
  List<Coupon> coupons = <Coupon>[];

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts({String message}) async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateSubtotal();

        print("Cart Details ::::::::::::>>>>>>>>>>>>> " +
            carts[0].food.restaurant.id);
        restaurant_id = carts[0].food.restaurant.id;
      }
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    });
  }

  Future<void> refreshCarts() async {
    listenForCarts(message: S.current.carts_refreshed_successfuly);
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            S.current.the_food_was_removed_from_your_cart(_cart.food.name)),
      ));
    });
  }



  Future<void> getCouponsList() async {
    final Stream<Coupon> stream = await getCoupon(restaurant_id);
    stream.listen((Coupon coupon) {
      setState(() {
        coupons.add(coupon);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Coupon List Updated :::"),
      ));
    });
  }

  void doApplyCoupon(String code, {String message}) async {
    coupon = new Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon _coupon) async {
      coupon = _coupon;
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      // closeCode(false);

      setState(() {});
      // showCode = false;
      // discount = coupon.discount;
      print("Coupon Details ::::>>>>> " + coupon.toMap().toString());
      // listenForCarts();
      // calculateSubtotal();
      // saveCoupon(currentCoupon).then((value) => {
      //     });
    });
  }

  void getDeliveryFees(
      double subTotal, String city_id,  String restaurant_id) async {
    final Stream<DeliveryFee> stream =
    await deliveryFees(subTotal, city_id, restaurant_id);

    print("City ID :::::>>>>>>>>>" + city_id.toString());
    stream.listen((DeliveryFee value) {
      print("Delivery Fee ::::::::::::::::::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> " +
          value.data.toString());
      setState(() {});
      deliveryFee = value.data.ceilToDouble();
    }, onError: (a) {
      print(a);
    }, onDone: () {
      setState((){});
     return total = subTotal + taxAmount + deliveryFee;
      // calculateSubtotal();
    });
  }

  void calculateSubtotal() {
    subTotal = 0;
    carts.forEach((cart) {
      subTotal += cart.quantity * cart.food.price;
    });

    taxAmount = 0.0;

    if (discount != 0.0) {
      discountType == "percent"
          ? outof = (discount / 100) * subTotal
          : outof = discount;
      subTotal = subTotal - outof;
      total = subTotal + taxAmount + deliveryFee;
    } else {
      total = subTotal + taxAmount + deliveryFee;
    }
    setState(() {});
    print("out OF ::::>>>>> " + outof.toString());
    if (subTotal != 0.0) {
      getDeliveryFees(subTotal,city_id,restaurant_id);
      print("API Call Continuesly::");
    }
  }

  //
  // Color getCouponIconColor() {
  //   print(coupon.toMap());
  //
  //    if (coupon?.valid == false) {
  //     return Colors.redAccent;
  //   }else {
  //      return Colors.green;
  //    }
  //   return Theme.of(context).focusColor.withOpacity(0.7);
  // }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }
}
