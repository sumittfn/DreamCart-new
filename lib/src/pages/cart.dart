import 'package:Dreamcart/src/elements/CartBottomDetailsWidget.dart';
import 'package:Dreamcart/src/pages/coupnlist.dart';
import 'package:Dreamcart/src/repository/settings_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;
  int deliveryFee;
  bool applyCoupon;
  String code;
  bool reduce;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    reduce = false;
    applyCoupon = false;
    _con.city_id = widget.routeArgument.city_id;
    // _con.restaurant_id = widget.routeArgument.id;
    _con.coupon = widget.routeArgument.coupon;
    _con.discount = widget.routeArgument.discount == null
        ? 0.0
        : widget.routeArgument.discount;
    _con.discountType = widget.routeArgument.discountType;
    _con.listenForCarts();
    // _con.getCouponsList();
    // _con.doApplyCoupon(widget.routeArgument.promocode);
    // print("Discount ::::::::::::>>>>>>>>>> " + _con.discount.toString());
    // print("City Name :::::::::::::::::>>>>>>>>>>>>> " +
    //     widget.routeArgument.city);
    // _con.calculateSubtotal();
    // _con.getDeliveryFee(_con.city_id, _con.subTotal,widget.routeArgument.id);
    // print("DeliveryFee:::::>>>>>>" + _con.deliveryFee.toString());
    super.initState();
  }

  void applyCouponState(bool value) {
    setState(() {
      _con.showCode = value;
    });
  }

  void removeCoupon(double value, double deliveryFee) {
    setState(() {
      _con.discount = value;
      _con.deliveryFee = deliveryFee;
      // _con.calculateSubtotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _con.scaffoldKey,
      bottomNavigationBar: CartBottomDetailsWidget(
        con: _con,
        routeArgument: widget.routeArgument,
        couponState: applyCouponState,
        removeCoupon: removeCoupon,
        coupons: _con.coupons,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            if (widget.routeArgument.param == '/Food') {
              Navigator.of(context).pushReplacementNamed('/Food',
                  arguments: RouteArgument(
                      id: widget.routeArgument.id,
                      city_id: widget.routeArgument.city_id,
                      city: widget.routeArgument.city));
            } else if (widget.routeArgument.param == '/Menu') {
              Navigator.of(context).pushReplacementNamed('/Menu',
                  arguments: RouteArgument(
                      id: widget.routeArgument.id,
                      city_id: widget.routeArgument.city_id,
                      city: widget.routeArgument.city));
            } else if (widget.routeArgument.param == '/Product') {
              Navigator.of(context).pushReplacementNamed('/Product',
                  arguments: RouteArgument(
                      id: widget.routeArgument.id,
                      city_id: widget.routeArgument.city_id,
                      category_id: widget.routeArgument.category_id,
                      city: widget.routeArgument.city));
            } else if (widget.routeArgument.param == '/Category') {
              Navigator.of(context).pop();
              // Navigator.of(context).pushReplacementNamed('/Category',
              //     arguments: RouteArgument(
              //         id: widget.routeArgument.id,
              //         city_id: widget.routeArgument.city_id,
              //         city: widget.routeArgument.city,
              //     category_id: widget.routeArgument.category_id));
            } else {
              Navigator.of(context)
                  .pushReplacementNamed('/Pages', arguments: 1);
            }
          },
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).hintColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).cart,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshCarts,
        child: _con.carts.isEmpty
            ? EmptyCartWidget()
            : Stack(
                fit: StackFit.expand,
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Container(
                    // margin: EdgeInsets.only(bottom: 125),
                    padding: EdgeInsets.only(bottom: 15),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              leading: Icon(
                                Icons.shopping_cart,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                S.of(context).shopping_cart,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.display1,
                              ),
                              subtitle: Text(
                                S
                                    .of(context)
                                    .verify_your_quantity_and_click_checkout,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Swipe left or right to remove the selected items",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          ListView.separated(
                            padding: EdgeInsets.only(
                              top: 15,
                            ),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.carts.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 15);
                            },
                            itemBuilder: (context, index) {
                              return CartItemWidget(
                                cart: _con.carts.elementAt(index),
                                city_id: widget.routeArgument.city_id,
                                heroTag: 'cart',
                                increment: () {
                                  _con.incrementQuantity(
                                      _con.carts.elementAt(index));
                                },
                                decrement: () {
                                  _con.decrementQuantity(
                                      _con.carts.elementAt(index));
                                },
                                onDismissed: () {
                                  _con.removeFromCart(
                                      _con.carts.elementAt(index));
                                  _con.subTotal = _con.subTotal -
                                      _con.carts
                                          .elementAt(index)
                                          .getFoodPrice();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // _con.showCode == true
                  //     ? Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //           height: 150.0,
                  //           padding: const EdgeInsets.all(18),
                  //           margin: EdgeInsets.only(
                  //               bottom: 15,
                  //               top: MediaQuery.of(context).size.height < 800.0
                  //                   ? reduce == false
                  //                       ? 230.0
                  //                       : 150.0
                  //                   : 260.0),
                  //           decoration: BoxDecoration(
                  //               color: Theme.of(context).primaryColor,
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(20)),
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                     color: Theme.of(context)
                  //                         .focusColor
                  //                         .withOpacity(0.15),
                  //                     offset: Offset(0, 2),
                  //                     blurRadius: 5.0)
                  //               ]),
                  //           child: KeyboardAvoider(
                  //             focusPadding: 20.0,
                  //             child: TextField(
                  //               onTap: () {
                  //                 reduce = true;
                  //               },
                  //               keyboardType: TextInputType.text,
                  //               onSubmitted: (String value) {
                  //                 _con.doApplyCoupon(value);
                  //                 setState(() {});
                  //                 code = value;
                  //               },
                  //               onChanged: (String value) {
                  //                 code = value;
                  //               },
                  //               cursorColor: Theme.of(context).accentColor,
                  //               controller: TextEditingController()
                  //                 ..text = coupon?.code ?? '',
                  //               decoration: InputDecoration(
                  //                 contentPadding: EdgeInsets.symmetric(
                  //                     horizontal: 20, vertical: 15),
                  //                 floatingLabelBehavior:
                  //                     FloatingLabelBehavior.always,
                  //                 hintStyle:
                  //                     Theme.of(context).textTheme.bodyText1,
                  //                 suffixText: coupon?.valid == null
                  //                     ? ''
                  //                     : (coupon.valid
                  //                         ? S.of(context).validCouponCode
                  //                         : S.of(context).invalidCouponCode),
                  //                 suffixStyle: Theme.of(context)
                  //                     .textTheme
                  //                     .caption
                  //                     .merge(TextStyle(
                  //                         color: _con.getCouponIconColor())),
                  //                 suffixIcon: Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 15),
                  //                   child: GestureDetector(
                  //                     onTap: () {
                  //                       _con.doApplyCoupon(code);
                  //                     },
                  //                     child: Icon(
                  //                       Icons.confirmation_number,
                  //                       color: _con.getCouponIconColor(),
                  //                       size: 28,
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 hintText: S.of(context).haveCouponCode,
                  //                 border: OutlineInputBorder(
                  //                     borderRadius: BorderRadius.circular(30),
                  //                     borderSide: BorderSide(
                  //                         color: Theme.of(context)
                  //                             .focusColor
                  //                             .withOpacity(0.2))),
                  //                 focusedBorder: OutlineInputBorder(
                  //                     borderRadius: BorderRadius.circular(30),
                  //                     borderSide: BorderSide(
                  //                         color: Theme.of(context)
                  //                             .focusColor
                  //                             .withOpacity(0.5))),
                  //                 enabledBorder: OutlineInputBorder(
                  //                     borderRadius: BorderRadius.circular(30),
                  //                     borderSide: BorderSide(
                  //                         color: Theme.of(context)
                  //                             .focusColor
                  //                             .withOpacity(0.2))),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     : Container(),
                ],
              ),
      ),
    );
  }
}
