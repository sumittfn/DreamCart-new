import 'package:Dreamcart/src/elements/AddNewAddressDialog.dart';
import 'package:Dreamcart/src/elements/CircularLoadingWidget.dart';
import 'package:Dreamcart/src/elements/citybottommodelsheet.dart';
import 'package:Dreamcart/src/helpers/checkbox_form_field.dart';
import 'package:Dreamcart/src/models/cities.dart';
import 'package:flutter/material.dart';
import 'package:Dreamcart/src/repository/user_repository.dart';
import 'package:Dreamcart/src/repository/settings_repository.dart'
    as settingRepo;
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/address.dart' as model;
import '../../generated/i18n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/PaymentMethodListItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import 'package:Dreamcart/src/models/address.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({
    Key key,
    this.routeArgument,
  }) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;
  PaymentMethodList list;
  double amount;
  double actual_amount;
  Address deliveryAddress;
  List<Data> cityData;
  TextEditingController textEditingController = TextEditingController();
  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();
  ValueChanged<Address> onChanged;
  String id;

  bool exist = false;
  // List<model.Address> listAddress = [];

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForDeliveryAddress();
    deliveryAddress = Address();
    // actual_amount = 0.0;
    deliveryAddress.address = currentUser.value.address;
    actual_amount = widget.routeArgument.current_amount;
    // amount = 0.0;
    amount = widget.routeArgument.amount;
    list = new PaymentMethodList();
    print("Amount: - " + amount.toString());

    // _con.addresses.add(_con.deliveryAddress);
    print("City Name Delivery ::::::::::::::::>>>>>>>>> " +
        widget.routeArgument.city);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for(int i=0; _con.addresses.length > i; i++) {
      print("List Address ::::::::::::::::::>>>>>>>>>>>>>>>>>>>>> " +
          _con.addresses.elementAt(i).toMap().toString());
    }
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back,
            size: 25.0,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              '/Cart',
              arguments: RouteArgument(
                  id: widget.routeArgument.id,
                  amount: widget.routeArgument.amount,
                  current_amount: widget.routeArgument.current_amount,
                  city_id: widget.routeArgument.city_id,
                  city: widget.routeArgument.city),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).delivery_or_pickup,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
            iconColor: Theme.of(context).hintColor,
            labelColor: Theme.of(context).accentColor,
            city_id: widget.routeArgument.city_id,
            city: widget.routeArgument.city,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _con.carts.isNotEmpty &&
                    Helper.canDelivery(_con.carts[0].food.restaurant,
                        carts: _con.carts)
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 10, left: 20, right: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.map,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            S.of(context).delivery,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.display1,
                          ),
                          subtitle: Text(
                            S
                                .of(context)
                                .click_to_confirm_your_address_and_pay_or_long_press,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      // currentUser.value.address == null
                      //     ? SizedBox()
                      //     : InkWell(
                      //         onTap: () {
                      //           Navigator.of(context).pushNamed(
                      //               '/PaymentMethod',
                      //               arguments: RouteArgument(
                      //                   id: widget.routeArgument.id,
                      //                   amount: amount,
                      //                   address: deliveryAddress,
                      //                   promocode:
                      //                       widget.routeArgument.promocode,
                      //                   discount: widget.routeArgument.discount,
                      //                   city: widget.routeArgument.city,
                      //                   city_id: widget.routeArgument.city_id,
                      //                   deliveryFee:
                      //                       widget.routeArgument.deliveryFee,
                      //               ));
                      //         },
                      //         onLongPress: () {
                      //           showDialog(
                      //               context: context,
                      //               builder: (context) {
                      //                 return DeliveryAddressDialog(
                      //                   routeArgument: RouteArgument(
                      //                       id: widget.routeArgument.id,
                      //                       amount: amount,
                      //                       city_id:
                      //                           widget.routeArgument.city_id,
                      //                       discount:
                      //                           widget.routeArgument.discount,
                      //                       promocode:
                      //                           widget.routeArgument.promocode,
                      //                       city: widget.routeArgument.city,
                      //                       deliveryFee: widget
                      //                           .routeArgument.deliveryFee),
                      //                   city_id: widget.routeArgument.city_id,
                      //                   cityName: widget.routeArgument.city,
                      //                   context: context,
                      //                   useraddress: currentUser.value.address,
                      //                   cityData: _con.cityData,
                      //                   address: _con.deliveryAddress,
                      //                   onChanged: (Address _address) {
                      //                     _con.addAddress(_address);
                      //                     _con.addresses.add(_address);
                      //                     print("Address List:- " +
                      //                         _con.addresses.toString());
                      //                   },
                      //                 );
                      //               });
                      //         },
                      //         child: Container(
                      //           padding: EdgeInsets.symmetric(
                      //               horizontal: 20, vertical: 12),
                      //           decoration: BoxDecoration(
                      //             color: Theme.of(context)
                      //                 .primaryColor
                      //                 .withOpacity(0.9),
                      //             boxShadow: [
                      //               BoxShadow(
                      //                   color: Theme.of(context)
                      //                       .focusColor
                      //                       .withOpacity(0.1),
                      //                   blurRadius: 5,
                      //                   offset: Offset(0, 2)),
                      //             ],
                      //           ),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: <Widget>[
                      //               Container(
                      //                 height: 55,
                      //                 width: 55,
                      //                 decoration: BoxDecoration(
                      //                     borderRadius: BorderRadius.all(
                      //                         Radius.circular(5)),
                      //                     color: Theme.of(context).accentColor),
                      //                 child: Icon(
                      //                   Icons.place,
                      //                   color: Theme.of(context).primaryColor,
                      //                   size: 38,
                      //                 ),
                      //               ),
                      //               SizedBox(width: 15),
                      //               Flexible(
                      //                 child: Row(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.center,
                      //                   children: <Widget>[
                      //                     Expanded(
                      //                       child: Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: <Widget>[
                      //                           Text(
                      //                             currentUser.value.address,
                      //                             style: Theme.of(context)
                      //                                 .textTheme
                      //                                 .subhead,
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                     SizedBox(width: 8),
                      //                     Icon(
                      //                       Icons.keyboard_arrow_right,
                      //                       color: Theme.of(context).focusColor,
                      //                     ),
                      //                   ],
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      SizedBox(height: 10),
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.addresses.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return DeliveryAddressesItemWidget(
                            address: _con.addresses[index],
                            onPressed: (Address _address) {
                              Navigator.of(context).pushNamed('/PaymentMethod',
                                  arguments: RouteArgument(
                                      id: widget.routeArgument.id,
                                      amount: amount,
                                      address: _con.addresses[index],
                                      promocode: widget.routeArgument.promocode,
                                      discount: widget.routeArgument.discount,
                                      city: widget.routeArgument.city,
                                      city_id: widget.routeArgument.city_id,
                                      deliveryFee:
                                          widget.routeArgument.deliveryFee));
                              // }
                            },
                            onLongPress: (Address _address) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeliveryAddressDialog(
                                      routeArgument: RouteArgument(
                                          id: widget.routeArgument.id,
                                          amount: amount,
                                          city_id: widget.routeArgument.city_id,
                                          discount:
                                              widget.routeArgument.discount,
                                          promocode:
                                              widget.routeArgument.promocode,
                                          city: widget.routeArgument.city,
                                          deliveryFee:
                                              widget.routeArgument.deliveryFee),
                                      context: context,
                                      address: _address,
                                      cityData: _con.cityData,
                                      onChanged: (Address _address) {
                                        _con.updateAddress(_address);
                                      },
                                      useraddress:_address.address ,
                                      city_id: widget.routeArgument.city_id,
                                      cityName: widget.routeArgument.city,
                                    );
                                  });
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return NewAddressDialog(
                                  routeArgument: RouteArgument(
                                      id: widget.routeArgument.id,
                                      amount: amount,
                                      city_id: widget.routeArgument.city_id,
                                      discount: widget.routeArgument.discount,
                                      promocode: widget.routeArgument.promocode,
                                      city: widget.routeArgument.city,
                                      deliveryFee:
                                          widget.routeArgument.deliveryFee),
                                  context: context,
                                  address: _con.deliveryAddress,
                                  listAddress: _con.addresses,
                                  onChanged: (Address _address) {
                                    _con.addAddress(_address);
                                  },
                                  cityData: _con.cityData,
                                  cityName: widget.routeArgument.city,
                                  city_id: widget.routeArgument.city_id,
                                );
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Theme.of(context).accentColor),
                                child: Icon(
                                  Icons.place,
                                  color: Theme.of(context).primaryColor,
                                  size: 38,
                                ),
                              ),
                              SizedBox(width: 15),
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Add your address",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subhead,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Theme.of(context).focusColor,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    height: 100.0,
                    child: new Center(
                      child: new CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
