import 'dart:collection';
import 'dart:convert';

import 'package:Dreamcart/src/models/cities.dart';
import 'package:Dreamcart/src/repository/restaurant_repository.dart';
import 'package:Dreamcart/src/repository/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/address.dart';
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class DeliveryPickupController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
 Address deliveryAddress;
  List<Address> addresses = <Address>[];
  List<Cart> carts = [];
  List<Address> result = [];
  List<Data> cityData = <Data>[];

  DeliveryPickupController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    selectCity();
    listenForCart();
    listenForDeliveryAddress();
    changeCurrentLocation(deliveryAddress);

  }

  Future<void> selectCity() async {
    final Stream<Data> stream = await getCitiesList();
    stream.listen((Data city) {
      setState(() => cityData.add(city));
    }, onError: (a) {
      print("Error" + a.toString());
    }, onDone: () {

    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      setState(() {
        carts.add(_cart);
      });
    });
  }

  void listenForDeliveryAddress({String message}) async {
    // getCurrentLocation();
    this.deliveryAddress = settingRepo.deliveryAddress.value;

    final Stream<Address> stream = await userRepo.getAddresses();
    stream.listen((Address _address) {
      setState(() {
        addresses.add(_address);
// print("Data Address Print :::::::::::::::::::::>>>>>>>>>>>>>> " + _address.toMap().toString());
      });


    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {

      for(int i =0; i< addresses.length; i++){
        for(int  j =1; j<addresses.length; j++){
          if(addresses[i].id == addresses[j].id){
          this.addresses.removeAt(j);
          }
        }

        print("List Address ::::::::::::>>>>>>>>>>>>>>>>> " + addresses.toString());
      }

      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
          duration: Duration(milliseconds: 300),
        ));
      }
    });

  }

  void addAddress(Address address) {
   print("Delivery address::::::::::>>>>>>> " + address.address);
    userRepo.addAddress(address).then((value) {
      setState(() {
        this.addresses.add(value);

        print("Address Value  New ::::::::::::::>>>>>" + value.toString());

        settingRepo.deliveryAddress.value = value;
        // this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.new_address_added_successfully),
      ));
    });
  }

  void updateAddress(Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;

      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.the_address_updated_successfully),
      ));
    });
  }
}
