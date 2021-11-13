import 'package:Dreamcart/src/controllers/couponcontroller.dart';
import 'package:Dreamcart/src/models/coupon.dart';
import 'package:Dreamcart/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CouponData extends StatefulWidget {
final  Coupon coupon;
final RouteArgument routeArgument;
 final CouponController con;

  const CouponData({Key key, this.coupon, this.routeArgument, this.con}) : super(key: key);
  @override
  _CouponDataState createState() => _CouponDataState();
}

class _CouponDataState extends State<CouponData> {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 200.0,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.orangeAccent,
                width: 1.5,
              )),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Code: ",
                        style: TextStyle(
                            color: Colors.green,fontSize: 14.0)),
                    TextSpan(
                        text: widget.coupon.code,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold))
                  ]),
                  // children: [
                  //   Text(
                  //     widget.coupon.code,
                  //     style: TextStyle(
                  //         fontSize: 14.0,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ],
                ),
                InkWell(
                    onTap: () {
                      widget.con.doApplyCoupon(
                          widget.coupon.code);
                      Navigator.pushNamed(
                          context, '/Cart',
                          arguments: RouteArgument(
                              city_id: widget
                                  .routeArgument.city_id,
                              city: widget
                                  .routeArgument.city,
                              id: widget.routeArgument.id,
                              promocode:
                              widget.coupon.code,
                              discount: widget.coupon
                                  .discount,
                              coupon: widget.coupon,
                              discountType: widget.coupon
                                  .discountType));
                      // _sendDataBack(context);
                    },
                    child: Container(
                        height: 25.0,
                        width: 80.0,
                        color: Colors.green,
                        child: Center(
                            child: Text(
                              "Apply Code",
                              style: TextStyle(
                                  color: Colors.white),
                            )))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Html(
              data: widget.coupon.description,
              defaultTextStyle: Theme.of(context)
                  .textTheme
                  .body1
                  .merge(TextStyle(fontSize: 14)),
            ),
          )
        ],
      ),
    );
  }
}
