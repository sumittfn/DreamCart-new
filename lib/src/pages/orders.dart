import 'package:Dreamcart/src/models/cities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/order_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  String city_id;
  List<Data> city;
  String cityName;
  OrdersWidget(
      {Key key, this.parentScaffoldKey, this.city_id, this.city, this.cityName})
      : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  OrderController _con;

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller;
  }

  void initState() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).my_orders,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              city_id: widget.city_id,
              cityData: widget.city,
              city: widget.cityName,
              param: "/Orders",
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : RefreshIndicator(
              onRefresh: _con.refreshOrders,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SearchBarWidget(city_id: widget.city_id,city_name: widget.cityName,),
                    ),
                    SizedBox(height: 10),
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.orders.length,
                      itemBuilder: (context, index) {
                        var _order = _con.orders.elementAt(index);
                        return Theme(
                          data: theme,
                          child: ExpansionTile(
                            initiallyExpanded: index == 0 ? true : false,
                            title: Column(
                              children: <Widget>[
                                Text(
                                    '${S.of(context).order_id}: #${_con.orders.elementAt(index).id}'),
                                Text(
                                  '${_con.orders.elementAt(index).orderStatus.status}',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Helper.getPrice(
                                    Helper.getTotalOrdersPrice(_order), context,
                                    style:
                                        Theme.of(context).textTheme.display1),
                                Text(
                                  DateFormat('dd-MM | HH:mm')
                                      .format(_order.dateTime),
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ),
                            children: <Widget>[
                              Column(
                                  children: List.generate(
                                _order.foodOrders.length,
                                (indexFood) {
                                  return OrderItemWidget(
                                      heroTag: 'my_orders',
                                      order: _order,
                                      city: widget.cityName,
                                      city_id: widget.city_id,
                                      foodOrder: _order.foodOrders
                                          .elementAt(indexFood));
                                },
                              )),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Column(
                                  children: <Widget>[
                                    // Row(
                                    //   children: <Widget>[
                                    //     Expanded(
                                    //       child: Text(
                                    //         S.of(context).delivery_fee,
                                    //         style: Theme.of(context)
                                    //             .textTheme
                                    //             .body2,
                                    //       ),
                                    //     ),
                                    //     Helper.getPrice(
                                    //         _order.deliveryFee, context,
                                    //         style: Theme.of(context)
                                    //             .textTheme
                                    //             .subhead)
                                    //   ],
                                    // ),
                                    // Row(
                                    //   children: <Widget>[
                                    //     Expanded(
                                    //       child: Text(
                                    //         '${S.of(context).tax} (${_order.tax}%)',
                                    //         style: Theme.of(context)
                                    //             .textTheme
                                    //             .body2,
                                    //       ),
                                    //     ),
                                    //     Helper.getPrice(
                                    //         Helper.getTaxOrder(_order),
                                    //         context,
                                    //         style: Theme.of(context)
                                    //             .textTheme
                                    //             .subhead)
                                    //   ],
                                    // ),
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
                                            Helper.getTotalOrdersPrice(_order),
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
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 30,
                          color: Theme.of(context).hintColor.withOpacity(0.1),
                        );
                      },
                    ),
                    _con.orders.isEmpty
                        ? Container(
                            child: Center(child: Text("No orders found.")),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
    );
  }
}
