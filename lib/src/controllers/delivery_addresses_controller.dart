import 'package:Dreamcart/src/models/address.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/address.dart' as model;
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class DeliveryAddressesController extends ControllerMVC with ChangeNotifier {
  List<Address> addresses = <Address>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Cart cart;
  List<Address> listaddresses = <Address>[];

  DeliveryAddressesController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForAddresses();
    listenForCart();
  }

  void listenForAddresses({String message}) async {
    final Stream<Address> stream = await userRepo.getAddresses();
    stream.listen((Address _address) {
      setState(() {
        addresses.add(_address);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      for(int i =0; i< addresses.length; i++) {
        for (int j = 1; j < addresses.length; j++) {
          if (addresses[i].id == addresses[j].id) {
            this.addresses.removeAt(j);
          }
        }
        listaddresses = addresses;
        if (message != null) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(milliseconds: 300),
          ));
        }
      }
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      cart = _cart;
    });
  }

  Future<void> refreshAddresses() async {
    addresses.clear();
    listenForAddresses(message: S.current.addresses_refreshed_successfuly);
  }

  Future<void> changeDeliveryAddress(Address address) async {
    await settingRepo.changeCurrentLocation(address);
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  Future<void> changeDeliveryAddressToCurrentLocation() async {
   Address _address = await settingRepo.getCurrentLocation();
    setState(() {
      settingRepo.deliveryAddress.value = _address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  void addAddress(Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        this.addresses.insert(0, value);
      });
      scaffoldKey?.currentState?.showSnackBar(
        SnackBar(
          content: Text(S.current.new_address_added_successfully),
          duration: Duration(milliseconds: 300),
        ),
      );
    });
  }

  void chooseDeliveryAddress(Address address) {
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  void updateAddress(Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {});
      addresses.clear();
      listenForAddresses(message: S.current.the_address_updated_successfully,);
    });
  }

  void removeDeliveryAddress(Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.delivery_address_removed_successfully),
      ));
    });
  }
}
