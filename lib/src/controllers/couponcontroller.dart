

import 'package:Dreamcart/generated/i18n.dart';
import 'package:Dreamcart/src/models/coupon.dart';
import 'package:Dreamcart/src/repository/coupon_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class CouponController extends ControllerMVC {
  List <Coupon> coupons = <Coupon>[];
  Coupon coupon;
  String restaurant_id;
  GlobalKey<ScaffoldState> scaffoldKey;


  CouponController(){
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    getCouponsList();
  }

  void getCouponsList()async{
    final Stream<Coupon> stream = await getCoupon(restaurant_id);
    stream.listen((Coupon _coupon) {
      if(!coupons.contains(_coupon)) {
        setState(() {
          coupons.add(_coupon);
        });
      }
    },
    onError: (a){
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    },
    onDone: (){
      // scaffoldKey.currentState.showSnackBar(SnackBar(
      //   content: Text("Coupon List Updated :::"),
      // ));
    });
  }

 Future<void> refreshSearch(){
    setState((){
      coupons = <Coupon>[];

    });

     getCouponsList();


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

      setState((){});
      // showCode = false;
      // discount = coupon.discount;
      print("Coupon Details ::::>>>>> " + coupon.toMap().toString());
      // listenForCarts();
      // calculateSubtotal();
      // saveCoupon(currentCoupon).then((value) => {
      //     });
    });
  }
}



