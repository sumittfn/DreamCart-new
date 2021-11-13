import '../models/address.dart';
import '../models/food_order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';

class Order {
  String id;
  String user_id;
  String order_id_status;
  bool active;
  String driver_id;
  String payment_id;
  List<FoodOrder> foodOrders;
  OrderStatus orderStatus;
  double tax;
  String deliveryFee;
  String hint;
  DateTime dateTime;
  User user;
  Payment payment;
  Address deliveryAddress;
  String promocode;
  String discount;
  String delivery_address_id;
  String created_at;
  String updated_at;
  String drivers;

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      user_id = jsonMap['user_id'].toString();
      order_id_status = jsonMap['order_id_status'].toString();
      active = jsonMap['active'];
      driver_id = jsonMap['driver_id'].toString();
      payment_id = jsonMap['payment_id'].toString();
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      deliveryFee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee']
          : "0.0";
      hint = jsonMap['hint'] == null ? null : jsonMap['hint'];
      orderStatus = jsonMap['order_status'] != null
          ? OrderStatus.fromJSON(jsonMap['order_status'])
          : new OrderStatus();
      dateTime = DateTime.parse(jsonMap['updated_at']);
      user =
          jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
      deliveryAddress = jsonMap['delivery_address'] != null
          ? Address.fromJSON(jsonMap['delivery_address'])
          : new Address();
      foodOrders = jsonMap['food_orders'] != null
          ? List.from(jsonMap['food_orders'])
              .map((element) => FoodOrder.fromJSON(element))
              .toList()
          : [];
      delivery_address_id = jsonMap['delivery_address_id'].toString();
      created_at = jsonMap['created_at'].toString();
      updated_at = jsonMap['updated_at'].toString();
      drivers = jsonMap['drivers'].toString();
      promocode = jsonMap['promocode'].toString();
      discount = jsonMap['discount'] != null
          ? jsonMap['discount']
          : "0.0";
    } catch (e) {
      id = '';
      tax = 0.0;
      deliveryFee = "0.0";
      hint = '';
      discount ='0.0';
      orderStatus = new OrderStatus();
      dateTime = DateTime(0);
      user = new User();
      deliveryAddress = new Address();
      foodOrders = [];
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = user_id;
    map["order_id_status"] = order_id_status;
    map["active"] = active;
    map["drivers_id"] = driver_id;
    map["payment_id"] = payment_id;
    map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map["delivery_fee"] = deliveryFee;
    map["foods"] = foodOrders.map((element) => element.toMap()).toList();
    map["payment"] = payment.toMap();
    map["promocode"] = promocode;
    map["discount"] = discount;
    map["delivery_address_id"] = delivery_address_id;
    map["created_at"] = created_at;
    map["updated_at"] = updated_at;
    map["drivers"] = drivers;
    if (deliveryAddress?.id != null && deliveryAddress?.id != 'null')
      map["delivery_address_id"] = deliveryAddress.id;
    return map;
  }
}
