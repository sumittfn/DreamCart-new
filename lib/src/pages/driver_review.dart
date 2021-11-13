import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/reviews_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/route_argument.dart';

class DriverReviewWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DriverReviewWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DriverReviewWidgetState createState() {
    return _DriverReviewWidgetState();
  }
}

class _DriverReviewWidgetState extends StateMVC<DriverReviewWidget> {
  ReviewsController _con;

  _DriverReviewWidgetState() : super(ReviewsController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForOrder(orderId: widget.routeArgument.id);
    super.initState();
  }

  void _sendDataBack(BuildContext context) {
    String textToSendBack = _con.driverReview.rate;
    Navigator.pop(context, textToSendBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _sendDataBack(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.green,
            ),
          ),
        ),
        key: _con.scaffoldKey,
        body: RefreshIndicator(
            onRefresh: _con.refreshOrder,
            child: _con.order == null
                ? CircularLoadingWidget(height: 500)
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          _con.order.drivers,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.display2,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
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
                              Text(
                                  S.of(context).how_would_you_rate_delivery_boy,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subhead),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _con.driverReview.rate =
                                            (index + 1).toString();
                                      });
                                    },
                                    child: index <
                                            int.parse(_con.driverReview.rate)
                                        ? Icon(Icons.star,
                                            size: 40, color: Color(0xFFFFB24D))
                                        : Icon(Icons.star_border,
                                            size: 40, color: Color(0xFFFFB24D)),
                                  );
                                }),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                onChanged: (text) {
                                  _con.driverReview.review = text;
                                },
                                maxLines: 2,
                                maxLength: 1000,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1000),
                                ],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: S
                                      .of(context)
                                      .tell_us_about_this_delivery_boy,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .merge(TextStyle(fontSize: 14)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.1))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.2))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.1))),
                                ),
                              ),
                              SizedBox(height: 10),
                              FlatButton.icon(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 18),
                                onPressed: () {
                                  _con.driverReview.driver_id =
                                      _con.order.driver_id;
                                  _con.addDriverReview(_con.driverReview);
                                  FocusScope.of(context).unfocus();
                                },
                                shape: StadiumBorder(),
                                label: Text(
                                  S.of(context).submit,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                icon: Icon(
                                  Icons.check,
                                  color: Theme.of(context).primaryColor,
                                ),
                                textColor: Theme.of(context).primaryColor,
                                color: Theme.of(context).accentColor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )));
  }
}
