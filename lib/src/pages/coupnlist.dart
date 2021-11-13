import 'package:Dreamcart/generated/i18n.dart';
import 'package:Dreamcart/src/controllers/couponcontroller.dart';
import 'package:Dreamcart/src/elements/CircularLoadingWidget.dart';
import 'package:Dreamcart/src/elements/Coupon.dart';
import 'package:Dreamcart/src/models/coupon.dart';
import 'package:Dreamcart/src/models/route_argument.dart';
import 'package:Dreamcart/src/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class CoupnListWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CoupnListWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CoupnListWidgetState createState() => _CoupnListWidgetState();
}

class _CoupnListWidgetState extends StateMVC<CoupnListWidget> {
  String filter = "";
  CouponController con;
  TextEditingController textcontroller = new TextEditingController();

  _CoupnListWidgetState() : super(CouponController()) {
    con = controller;
  }

  void initState() {
    con.restaurant_id = widget.routeArgument.id;
    con.getCouponsList();
    super.initState();
  }
  // void _sendDataBack(BuildContext context) {
  //   Coupon coupon = con.coupon;
  //   Navigator.pop(context, coupon);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          title: Text(
            "Coupons",
            style: Theme.of(context)
                .textTheme
                .title
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: con.coupons.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: CircularLoadingWidget(
                    height: 255.0,
                  ))
              : con.coupons.length == 0
                  ? Text("No coupons found")
                  : ListView.separated(
                      // reverse: true,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10.0,
                        );
                      },
                      itemCount: con.coupons.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CouponData(
                          routeArgument: widget.routeArgument,
                          coupon: con.coupons.elementAt(index),
                          con: con,
                        );
                      },
                      shrinkWrap: true,
                    ),
        ));
  }

  List<Widget> couponList() {
    List<Widget> couponList = [];

    for (int i = 0; i < con.coupons.length; i++) {
      couponList.add(
        Expanded(
          child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Code: ",
                              style: TextStyle(
                                  color: Colors.green, fontSize: 14.0)),
                          TextSpan(
                              text: con.coupons[i].code,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold))
                        ]),
                        // children: [
                        //   Text(
                        //     con.coupons[index].code,
                        //     style: TextStyle(
                        //         fontSize: 14.0,
                        //         fontWeight: FontWeight.bold),
                        //   ),
                        // ],
                      ),
                      InkWell(
                          onTap: () {
                            con.doApplyCoupon(con.coupons[i].code);
                            Navigator.pushNamed(context, '/Cart',
                                arguments: RouteArgument(
                                    city_id: widget.routeArgument.city_id,
                                    city: widget.routeArgument.city,
                                    id: widget.routeArgument.id,
                                    promocode: con.coupons[i].code,
                                    discount: con.coupons[i].discount,
                                    coupon: con.coupon,
                                    discountType: con.coupons[i].discountType));
                            // _sendDataBack(context);
                          },
                          child: Container(
                              height: 25.0,
                              width: 80.0,
                              color: Colors.green,
                              child: Center(
                                  child: Text(
                                "Apply Code",
                                style: TextStyle(color: Colors.white),
                              )))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Html(
                    data: con.coupons[i].description,
                    defaultTextStyle: Theme.of(context)
                        .textTheme
                        .body1
                        .merge(TextStyle(fontSize: 14)),
                  ),
                ),
                // Container(width: 300.0,height: 2.0,color: Colors.orangeAccent,)
              ],
            ),
          ),
        ),
      );
    }
    return couponList;
  }
}
