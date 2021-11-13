import 'package:flutter/material.dart';
import 'package:Dreamcart/src/controllers/delivery_pickup_controller.dart';
import 'package:Dreamcart/src/elements/DeliveryAddressDialog.dart';
import 'package:Dreamcart/src/elements/DeliveryAddressesItemWidget.dart';
import 'package:Dreamcart/src/helpers/helper.dart';
import 'package:Dreamcart/src/models/address.dart';
import 'package:Dreamcart/src/repository/user_repository.dart';

import '../../generated/i18n.dart';
import '../elements/PaymentMethodListItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import 'delivery_pickup.dart';

class PaymentMethodsWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  PaymentMethodsWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _PaymentMethodsWidgetState createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends State<PaymentMethodsWidget> {
  PaymentMethodList list;
  DeliveryPickupController _con;

  @override
  void initState() {
    list = new PaymentMethodList();
// _con.listenForDeliveryAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Address::::::::::::::::>>>>>>>>>>>>>>>>>>>>>>> - " +
        widget.routeArgument.address.toString());
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.arrow_back,
            size: 25.0,
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/Cart',
                arguments: RouteArgument(
                    param: '/Pages',
                    id: '2',
                    city_id: widget.routeArgument.city_id,
                    city: widget.routeArgument.city));
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).payment_mode,
          style: Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
            iconColor: Theme.of(context).hintColor,
            labelColor: Theme.of(context).accentColor,
            city: widget.routeArgument.city,
            city_id: widget.routeArgument.city_id,
            param: "/PaymentMethod",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(city_id: widget.routeArgument.city_id,city_name: widget.routeArgument.city,),
            ),
            SizedBox(height: 15),
            list.paymentsList.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.payment,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).payment_options,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.display1,
                      ),
                      subtitle: Text(
                          S.of(context).select_your_preferred_payment_mode),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            SizedBox(height: 10),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.paymentsList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(
                  paymentMethod: list.paymentsList.elementAt(index),
                  amount: widget.routeArgument.amount,
                  contact_no: currentUser.value.phone,
                  email: currentUser.value.email,
                  name: currentUser.value.name,
                  address: widget.routeArgument.address,
                  discount: widget.routeArgument.discount,
                  promoCode: widget.routeArgument.promocode == null
                      ? ""
                      : widget.routeArgument.promocode,
                  deliveryFee: widget.routeArgument.deliveryFee,
                );
              },
            ),
            list.cashList.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.monetization_on,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).cash_on_delivery,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.display1,
                      ),
                      subtitle: Text(
                          S.of(context).select_your_preferred_payment_mode),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.cashList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(
                  paymentMethod: list.cashList.elementAt(index),
                  amount: widget.routeArgument.amount,
                  contact_no: currentUser.value.phone,
                  email: currentUser.value.email,
                  name: currentUser.value.name,
                  discount: widget.routeArgument.discount,
                  promoCode: widget.routeArgument.promocode,
                  address: widget.routeArgument.address,
                  deliveryFee: widget.routeArgument.deliveryFee,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
