import 'package:Dreamcart/generated/i18n.dart';
import 'package:Dreamcart/src/models/coupon.dart';
import 'package:Dreamcart/src/models/route_argument.dart';
import 'package:Dreamcart/src/pages/coupnlist.dart';
import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';

class CartBottomDetailsWidget extends StatefulWidget {
  CartBottomDetailsWidget({
    Key key,
    this.couponState,
    this.routeArgument,
    this.removeCoupon,
    this.coupons,
    @required CartController con,
  })  : _con = con,
        super(key: key);
  List<Coupon> coupons;
  final CartController _con;
  Function couponState;
  Function removeCoupon;
  final RouteArgument routeArgument;

  @override
  _CartBottomDetailsWidgetState createState() =>
      _CartBottomDetailsWidgetState();
}

class _CartBottomDetailsWidgetState extends State<CartBottomDetailsWidget> {
  bool changeState;
  Coupon coupon;

  void initState() {
    changeState = false;
    super.initState();
  }

  // void _awaitReturnValueFromSecondScreen(BuildContext context) async {
  //   // start the SecondScreen and wait for it to finish with a result
  //   final result = await Navigator.of(context).pushNamed('/Coupon',
  //       arguments: RouteArgument(
  //         id: widget.routeArgument.id,
  //         city_id: widget.routeArgument.city_id,
  //         city: widget.routeArgument.city,
  //         discount: widget.routeArgument.discount,
  //         amount: widget.routeArgument.amount,
  //         coupon: widget.routeArgument.coupon,
  //         promocode: widget.routeArgument.promocode,
  //       ));
  //
  //   // after the SecondScreen result comes back update the Text widget with it
  //   setState(() {
  //     widget._con.coupon = result;
  //     widget._con.calculateSubtotal();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return widget._con.carts.isEmpty
        ? SizedBox(height: 0)
        : Container(
            height: 227.0,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.15),
                      offset: Offset(0, -2),
                      blurRadius: 5.0)
                ]),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pushNamed(
                          context,
                          "/Coupon",
                          arguments: RouteArgument(
                              id: widget.routeArgument.id,
                              city_id: widget.routeArgument.city_id,
                              city: widget.routeArgument.city,
                              discount: widget.routeArgument.discount,
                              amount: widget.routeArgument.amount,
                              coupon: widget.routeArgument.coupon,
                              coupons: widget.coupons
                              // promocode:
                              //     widget.routeArgument.promocode,
                              ),
                        );
                        //   widget.removeCoupon(0.0,widget._con.deliveryFee);
                        //   widget._con.outof = 0.0;
                        //   changeState = !changeState;
                        //
                        // widget.couponState(changeState);
                      });
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Container(
                          width: 135.0,
                          height: 18.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/img/coupon.png",
                                height: 30.0,
                                width: 30.0,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Text(
                                "Apply coupon ",
                                style: Theme.of(context).textTheme.body2,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).subtotal,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      Helper.getPrice(widget._con.subTotal, context,
                          style: Theme.of(context).textTheme.subhead)
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).delivery_fee,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      Text(widget._con.deliveryFee.ceilToDouble().toString(),
                          style: Theme.of(context).textTheme.subhead)
                    ],
                  ),
                  // widget._con.outof == 0.0 && widget._con.showCode == false
                  //     ? Container()
                  SizedBox(height: 5),
                  // widget._con.outof == 0.0 && widget._con.showCode == false
                  //     ? Container()
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).total_discount,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      Text(widget._con.outof.ceilToDouble().toString(),
                          style: Theme.of(context).textTheme.subhead)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${S.of(context).tax} (${widget._con.carts[0].food.restaurant.defaultTax}%)',
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      Helper.getPrice(widget._con.taxAmount, context,
                          style: Theme.of(context).textTheme.subhead)
                    ],
                  ),
                  SizedBox(height: 10),
                  Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: FlatButton(
                          onPressed: !widget
                                  ._con.carts[0].food.restaurant.closed
                              ? () {
                                  Navigator.of(context).pushNamed(
                                    '/DeliveryPickup',
                                    arguments: RouteArgument(
                                        id: widget.routeArgument.id,
                                        amount: widget._con.total,
                                        current_amount: widget._con.subTotal,
                                        discount: widget._con.outof,
                                        promocode: widget.routeArgument
                                                        .promocode ==
                                                    null ||
                                                widget.routeArgument
                                                        .promocode ==
                                                    ""
                                            ? ""
                                            : widget.routeArgument.promocode,
                                        city_id: widget.routeArgument.city_id,
                                        city: widget.routeArgument.city,
                                        deliveryFee: widget._con.deliveryFee),
                                  );

                                  print(
                                      "Delivery Fee::::::::::::::::>>>>>>>>>>>> " +
                                          widget._con.deliveryFee.toString());
                                  print(
                                      "Amount:::::::::::::::::::::::::::::::::>>>>>>>>>>>>>>>>>>>>>>>>> " +
                                          widget._con.total.toString());
                                }
                              : () {
                                  widget._con.scaffoldKey?.currentState
                                      ?.showSnackBar(SnackBar(
                                    content: Text(S
                                        .of(context)
                                        .this_restaurant_is_closed_),
                                  ));
                                },
                          disabledColor:
                              Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: !widget._con.carts[0].food.restaurant.closed
                              ? Theme.of(context).accentColor
                              : Theme.of(context).focusColor.withOpacity(0.5),
                          shape: StadiumBorder(),
                          child: Text(
                            S.of(context).checkout,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Helper.getPrice(
                          widget._con.total,
                          context,
                          style: Theme.of(context).textTheme.display1.merge(
                              TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
  }
}
