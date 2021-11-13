import 'package:Dreamcart/src/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/tracking_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class TrackingWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  TrackingWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _TrackingWidgetState createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends StateMVC<TrackingWidget> {
  TrackingController _con;
  String rate;

  _TrackingWidgetState() : super(TrackingController()) {
    _con = controller;
  }

  @override
  void initState() {
    rate = "0";
    _con.listenForOrder(orderId: widget.routeArgument.id);
    super.initState();
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {

    // start the SecondScreen and wait for it to finish with a result
    final result = await   Navigator.of(context).pushNamed(
        '/DriverReviews',
        arguments: RouteArgument(
          id: _con.order.id,
          heroTag: "driver_reviews",));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      rate = result;
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        accentColor: Theme.of(context).accentColor);
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).tracking_order,
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
        body: _con.order == null || _con.orderStatus.isEmpty
            ? CircularLoadingWidget(height: 300)
            : Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 115),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Theme(
                            data: theme,
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              title: Column(
                                children: <Widget>[
                                  Text(
                                      '${S.of(context).order_id}: #${_con.order.id}'),
                                  Text(
                                    '${_con.order.orderStatus.status}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              trailing: Helper.getPrice(
                                  Helper.getTotalOrdersPrice(_con.order),
                                  context,
                                  style: Theme.of(context).textTheme.display1),
                              children: <Widget>[
                                Column(
                                    children: List.generate(
                                  _con.order.foodOrders.length,
                                  (indexFood) {
                                    return OrderItemWidget(
                                        heroTag: 'my_orders',
                                        order: _con.order,
                                        foodOrder: _con.order.foodOrders
                                            .elementAt(indexFood));
                                  },
                                )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              S.of(context).delivery_fee,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body2,
                                            ),
                                          ),
                                          Helper.getPrice(
                                              double.parse(_con.order.deliveryFee), context,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subhead)
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              '${S.of(context).tax} (${_con.order.tax}%)',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body2,
                                            ),
                                          ),
                                          Helper.getPrice(
                                              Helper.getTaxOrder(_con.order),
                                              context,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subhead)
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              S.of(context).total,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body2,
                                            ),
                                          ),
                                          Helper.getPrice(
                                              Helper.getTotalOrdersPrice(
                                                  _con.order),
                                              context,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display1)
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Theme(
                              data: ThemeData(
                                primaryColor: Theme.of(context).accentColor,
                              ),
                              child: Stepper(
                                physics: ClampingScrollPhysics(),
                                controlsBuilder: (BuildContext context,
                                    {VoidCallback onStepContinue,
                                    VoidCallback onStepCancel}) {
                                  return SizedBox(height: 0);
                                },
                                steps: _con.getTrackingSteps(context),
                                currentStep: int.tryParse(
                                        this._con.order.orderStatus.id) -
                                    1,
                              ),
                            ),
                          ),
                          _con.order.deliveryAddress?.address != null
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Colors.black38
                                                    : Theme.of(context)
                                                        .backgroundColor),
                                        child: Icon(
                                          Icons.place,
                                          color: Theme.of(context).primaryColor,
                                          size: 38,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              currentUser.value.name == null
                                                  ? ""
                                                  : currentUser.value.name,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subhead,
                                            ),
                                            Text(
                                              _con.order.deliveryAddress
                                                      ?.address ??
                                                  "",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(height: 0),
                          SizedBox(height: 15),
                          _con.order.orderStatus.status == "On the Way" || _con.order.orderStatus.status == "Delivered"
                          ?     Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                          S
                                              .of(context)
                                              .how_would_you_rate_delivery_boy,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subhead),
                                      Text(
                                          S
                                              .of(context)
                                              .click_on_the_stars_below_to_leave_comments,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      SizedBox(height: 5),
                                      FlatButton(
                                        onPressed: () {
                                          _awaitReturnValueFromSecondScreen(context);
                                        },
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        shape: StadiumBorder(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: Helper.getStarsList(
                                              double.parse(rate
                                                  ),
                                              size: 35),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 135,
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(S.of(context).how_would_you_rate_this_restaurant,
                              style: Theme.of(context).textTheme.subhead),
                          Text(
                              S
                                  .of(context)
                                  .click_on_the_stars_below_to_leave_comments,
                              style: Theme.of(context).textTheme.caption),
                          SizedBox(height: 5),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/Reviews',
                                  arguments: RouteArgument(
                                      id: _con.order.id,
                                      heroTag: "restaurant_reviews"));
                            },
                            padding: EdgeInsets.symmetric(vertical: 5),
                            shape: StadiumBorder(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: Helper.getStarsList(
                                  double.parse(_con.order.foodOrders[0].food
                                      .restaurant.rate),
                                  size: 35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }
}
