import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:global_configuration/global_configuration.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';

import '../../generated/i18n.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/cart.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/restaurant.dart';
import '../repository/settings_repository.dart';

class Helper {
  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }

  static int getIntData(Map<String, dynamic> data) {
    return (data['data'] as int) ?? 0;
  }

  static bool getBoolData(Map<String, dynamic> data) {
    return (data['data'] as bool) ?? false;
  }

  static getObjectData(Map<String, dynamic> data) {
    return data['data'] ?? new Map<String, dynamic>();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

//   static Future<Marker> getMarker(Map<String, dynamic> res) async {
//     final Uint8List markerIcon = await getBytesFromAsset('assets/img/marker.png', 120);
//     final Marker marker = Marker(
//         markerId: MarkerId(res['id']),
//         icon: BitmapDescriptor.fromBytes(markerIcon),
// //        onTap: () {
// //          //print(res.name);
// //        },
//         anchor: Offset(0.5, 0.5),
//         infoWindow: InfoWindow(
//             title: res['name'],
//             snippet: res['distance'].toStringAsFixed(2) + ' mi',
//             onTap: () {
//               print('infowi tap');
//             }),
//         position: LatLng(double.parse(res['latitude']), double.parse(res['longitude'])));
//
//     return marker;
//   }
//
//   static Future<Marker> getMyPositionMarker(double latitude, double longitude) async {
//     final Uint8List markerIcon = await getBytesFromAsset('assets/img/my_marker.png', 120);
//     final Marker marker = Marker(
//         markerId: MarkerId(Random().nextInt(100).toString()),
//         icon: BitmapDescriptor.fromBytes(markerIcon),
//         anchor: Offset(0.5, 0.5),
//         position: LatLng(latitude, longitude));
//
//     return marker;
//   }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    }
    list.addAll(List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }));
    return list;
  }

//  static Future<List> getPriceWithCurrency(double myPrice) async {
//    final Setting _settings = await getCurrentSettings();
//    List result = [];
//    if (myPrice != null) {
//      result.add('${myPrice.toStringAsFixed(2)}');
//      if (_settings.currencyRight) {
//        return '${myPrice.toStringAsFixed(2)} ' + _settings.defaultCurrency;
//      } else {
//        return _settings.defaultCurrency + ' ${myPrice.toStringAsFixed(2)}';
//      }
//    }
//    if (_settings.currencyRight) {
//      return '0.00 ' + _settings.defaultCurrency;
//    } else {
//      return _settings.defaultCurrency + ' 0.00';
//    }
//  }

  static Widget getPrice(double myPrice, BuildContext context, {TextStyle style}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      if (myPrice == 0) {
        return Text('-', style: style ?? Theme.of(context).textTheme.subhead);
      }

      print("Price Total :::::::::::::::::::::::: >>>>>>>>>>>>>>>>>> " + myPrice.toString());
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value?.currencyRight != null && setting.value?.currencyRight == false
            ? TextSpan(
                text: setting.value?.defaultCurrency,
                style: style ?? Theme.of(context).textTheme.subhead,
                children: <TextSpan>[
                  TextSpan(text: myPrice.toString() ?? '', style: style ?? Theme.of(context).textTheme.subhead),
                ],
              )
            : TextSpan(
                text: myPrice.toString() ?? '',
                style: style ?? Theme.of(context).textTheme.subhead,
                children: <TextSpan>[
                  TextSpan(
                      text: setting.value?.defaultCurrency,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: style != null ? style.fontSize - 4 : Theme.of(context).textTheme.subhead.fontSize - 4)),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static double getTotalOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price * foodOrder.quantity;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price : 0;
    });
    return total;
  }

  static double getOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price : 0;
    });
    return total;
  }

  static double getTaxOrder(Order order) {
    double total = 0;
    order.foodOrders.forEach((foodOrder) {
      total += getTotalOrderPrice(foodOrder);
    });
    return order.tax * total / 100;
  }

  static double getTotalOrdersPrice(Order order) {
    double total = 0;
    order.foodOrders.forEach((foodOrder) {
      total += getTotalOrderPrice(foodOrder);
    });

    print("dDSelivery Fee ::::::::::::>>>>>>> " + order.deliveryFee.toString());
    total -= double.parse(order.discount);
    total += double.parse(order.deliveryFee);


    total += order.tax * total / 100;
    return total;
  }

  static String getDistance(double distance) {
    String unit = setting.value.distanceUnit;
    if (unit == 'km') {
      distance *= 1.60934;
    }
    return distance != null ? distance.toStringAsFixed(2) + " " + trans(unit) : "";
  }

  static bool canDelivery(Restaurant _restaurant, {List<Cart> carts}) {
    bool _can = true;
    carts?.forEach((Cart _cart) {
      _can &= _cart.food.deliverable;
    });
    _can &= _restaurant.availableForDelivery && (_restaurant.distance <= _restaurant.deliveryRange);
    return _can;
  }

  static String skipHtml(String htmlString) {
    try {
      var document = parse(htmlString);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    } catch (e) {
      return '';
    }
  }

  static Html applyHtml(context, String html, {TextStyle style}) {
    return Html(
      blockSpacing: 0,
      data: html ?? '',
      defaultTextStyle: style ?? Theme.of(context).textTheme.body2.merge(TextStyle(fontSize: 14)),
      useRichText: false,
      customRender: (node, children) {
        if (node is dom.Element) {
          switch (node.localName) {
            case "br":
              return SizedBox(
                height: 0,
              );
            case "p":
              return Padding(
                padding: EdgeInsets.only(top: 0, bottom: 0),
                child: Container(
                  width: double.infinity,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    children: children,
                  ),
                ),
              );
          }
        }
        return null;
      },
    );
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Theme.of(context).primaryColor.withOpacity(0.85),
          child: CircularLoadingWidget(height: 200),
        ),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      loader?.remove();
    });
  }

  static String limitString(String text, {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) + (text.length > limit ? hiddenText : '');
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number != null && number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ' + number.substring(4, 8);
      result += ' ' + number.substring(8, 12);
      result += ' ' + number.substring(12, 16);
    }
    return result;
  }

  static Uri getUri(String path) {
    String _path = Uri.parse(GlobalConfiguration().getString('base_url')).path;
    if (!_path.endsWith('/')) {
      _path += '/';
    }
    Uri uri = Uri(
        scheme: Uri.parse(GlobalConfiguration().getString('base_url')).scheme,
        host: Uri.parse(GlobalConfiguration().getString('base_url')).host,
        port: Uri.parse(GlobalConfiguration().getString('base_url')).port,
        path: _path + path);
    return uri;
  }

  static String trans(String text) {
    switch (text) {
      case "App\\Notifications\\StatusChangedOrder":
        return S.current.order_status_changed;
      case "App\\Notifications\\NewOrder":
        return S.current.new_order_from_client;
      case "km":
        return S.current.km;
      case "mi":
        return S.current.mi;
      default:
        return "";
    }
  }
}