import 'dart:convert';
import 'package:Dreamcart/src/models/route_argument.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/payment_method.dart';
import 'package:Dreamcart/src/models/address.dart';

// ignore: must_be_immutable
class PaymentMethodListItemWidget extends StatefulWidget {
  PaymentMethod paymentMethod;
  final String email;
  final String contact_no;
  final double amount;
  final double acctual_amount;
  final String name;
  final Address address;
  final String promoCode;
  final double discount;
  final double deliveryFee;
  PaymentMethodListItemWidget(
      {Key key,
      this.paymentMethod,
      this.email,
      this.contact_no,
      this.amount,
      this.name,
      this.acctual_amount,
      this.address,
      this.promoCode,
      this.discount, this.deliveryFee})
      : super(key: key);

  @override
  _PaymentMethodListItemWidgetState createState() =>
      _PaymentMethodListItemWidgetState();
}

class _PaymentMethodListItemWidgetState
    extends State<PaymentMethodListItemWidget> {
  String heroTag;
  double amount;

  Razorpay razorpay;

  void initState() {

    print("Delivery address:::::>>>>>>>>>>" + widget.address.address );
    print("Delivery Fee :::::::::::>>>>>>>>>> " + widget.deliveryFee.toString());
    if (widget.paymentMethod.id == "Take Away" ) {
      amount = widget.acctual_amount;
    } else {
      amount = widget.amount;
    }

    print("Coupon Details ::::::::::::: " + widget.promoCode == null ? "" :widget.promoCode);

    print("Discount Details ::::::::::::: " + widget.discount.toString());
    print("ID :- " + widget.paymentMethod.id);
    print("Amount ::::::::::::::::::::::::::::::::::::::::::::::_______ _" +
        widget.amount.toString());

    print("Delivery added address :::::::::::::::::::: >> " + widget.address.address);
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_f3two4xZDsS5fy',
      // 'rzp_live_f3two4xZDsS5fy',
      // rzp_test_aZFiNLWnLrrm3e,
      'amount': amount * 100,
      'name': widget.name,
      'description': 'Dreamcart',
      'prefill': {'contact': widget.contact_no, 'email': widget.email},
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("SUCCESS " + response.toString());
    Navigator.of(context).pushNamed('/OrderSuccess',
        arguments: RouteArgument(
            param: 'Pay Online',
            id: response.orderId,
            promocode: widget.promoCode,
            discount: widget.discount,
            amount: widget.amount,
            status: "Paid",
            address: widget.address,deliveryFee: widget.deliveryFee));
  }

  void _handleErrorFailure(PaymentFailureResponse response) {
    print("Error :- " + response.toString());
  }

  void _handleExternalWallet() {
    print("External");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        showDialog(
          context: context,
          builder:(context){
        return  AlertDialog(
              backgroundColor: Colors.white,
              content: Container(
                height: 100.0,
                width: 200.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Are you sure to place orders?"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          color: Colors.white,
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.orangeAccent),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          color: Colors.green,
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (widget.paymentMethod.id == "Pay Online" ||
                                // widget.paymentMethod.id == "cod" ||
                                widget.paymentMethod.id == "Take Away") {
                              /**/
                              openCheckout();
                            } else {
                              Navigator.of(context).pushNamed(
                                  this.widget.paymentMethod.route,
                                  arguments: RouteArgument(
                                      amount: widget.amount,
                                      param: widget.paymentMethod.id,
                                      discount: widget.discount,
                                      promocode: widget.promoCode,
                                      address: widget.address,
                                  deliveryFee: widget.deliveryFee));
                              print(this.widget.paymentMethod.name);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ));
      }
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                    image: AssetImage(widget.paymentMethod.logo),
                    fit: BoxFit.fill),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.paymentMethod.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Text(
                          widget.paymentMethod.description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
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
    );
  }
}
