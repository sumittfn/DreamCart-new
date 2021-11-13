import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/checkout_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../models/payment.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart' as settingRepo;

class OrderSuccessWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  OrderSuccessWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState extends StateMVC<OrderSuccessWidget> {
  CheckoutController _con;
  double amount;

  _OrderSuccessWidgetState() : super(CheckoutController()) {
    _con = controller;
  }

  @override
  void initState() {
    // route param contains the payment method
    _con.promocode = widget.routeArgument.promocode;
    _con.discount = widget.routeArgument.discount;
    _con.address = widget.routeArgument.address;
    _con.deliveryFee = widget.routeArgument.deliveryFee;

    print("DeliveryFee ::::::::::::::::::::::::>>>>>>>>>> " +
        _con.deliveryFee.toString());
    print("Promo Code :::::::::::::::::::>>>>>>>>>>>>>> " + _con.promocode);
    print("Discount ::::::::::::::::::::::::>>>>>>>>>> " +
        _con.discount.toString());
    // settingRepo.deliveryAddress.value = widget.routeArgument.address;
    _con.payment = new Payment(
      widget.routeArgument.param,
      widget.routeArgument.id,
      widget.routeArgument.status
    );
    _con.listenForCarts(withAddOrder: true);
    amount = widget.routeArgument.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Amount Final :::::::::::::::::::>>>>>>>> " +
        widget.routeArgument.amount.toString());
    // _con.total = widget.routeArgument.amount;
    return WillPopScope(
      onWillPop: () async {
        return  Navigator.of(context).pushNamed('/Pages', arguments: 1);
      },
      child: Scaffold(
          key: _con.scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Pages', arguments: 1);
              },
              icon: Icon(Icons.arrow_back),
              color: Theme.of(context).hintColor,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              S.of(context).confirmation,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .merge(TextStyle(letterSpacing: 1.3)),
            ),
          ),
          body: _con.carts.isEmpty
              ? CircularLoadingWidget(height: 500)
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      alignment: AlignmentDirectional.center,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Colors.green.withOpacity(1),
                                          Colors.green.withOpacity(0.2),
                                        ])),
                                child: _con.loading
                                    ? Padding(
                                        padding: EdgeInsets.all(55),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor),
                                        ),
                                      )
                                    : Icon(
                                        Icons.check,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        size: 90,
                                      ),
                              ),
                              Positioned(
                                right: -30,
                                bottom: -50,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(150),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: -20,
                                top: -50,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(150),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          Opacity(
                            opacity: 0.4,
                            child: Text(
                              S
                                  .of(context)
                                  .your_order_has_been_successfully_submitted,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .display2
                                  .merge(TextStyle(fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 155,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, -2),
                                  blurRadius: 5.0)
                            ]),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).total,
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                  ),
                                  Helper.getPrice(
                                      widget.routeArgument.amount, context,
                                      style: Theme.of(context).textTheme.title)
                                ],
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/Pages', arguments: 2);
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  color: Theme.of(context).accentColor,
                                  shape: StadiumBorder(),
                                  child: Text(
                                    S.of(context).my_orders,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
    );
  }
}
