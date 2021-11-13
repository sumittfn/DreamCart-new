import '../models/extra.dart';
import '../models/food.dart';

class Cart {
  String id;
  Food food;
  double quantity;
  List<Extra> extras;
  String userId;
  int reset;
  String api_token;

  Cart();

  Cart.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      quantity =
          jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
      food =
          jsonMap['food'] != null ? Food.fromJSON(jsonMap['food']) : new Food();
      extras = jsonMap['extras'] != null
          ? List.from(jsonMap['extras'])
              .map((element) => Extra.fromJSON(element))
              .toList()
          : [];
      reset =jsonMap['reset'];
      food.price = getFoodPrice();
      api_token = jsonMap['api_token'].toString();
    } catch (e) {
      id = '';
      api_token= '';
      reset = 0;
      quantity = 0.0;
      food = new Food();
      extras = [];
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["quantity"] = quantity;
    map["food_id"] = food.id;
    map["user_id"] = userId;
    map["reset"] = reset;
    map["extras"] = extras.map((element) => element.id).toList();
    map["api_token"] = api_token;
    return map;
  }

  double getFoodPrice() {
    double result = food.price;
    if (extras.isNotEmpty) {
      extras.forEach((Extra extra) {
        result += extra.price != null ? extra.price : 0;
      });
    }
    return result;
  }

  bool isSame(Cart cart) {
    bool _same = true;
    _same &= this.food == cart.food;
    _same &= this.extras.length == cart.extras.length;
    if (_same) {
      this.extras.forEach((Extra _extra) {
        _same &= cart.extras.contains(_extra);
      });
    }
    return _same;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}

class DeliveryFee {
  double data;
  String message;
  bool status;

  DeliveryFee({this.data, this.status, this.message});

  factory DeliveryFee.fromJson(Map<String, dynamic> json) =>
      DeliveryFee(
        message: json["message"],
        data: json["data"] == 0 ? 0.0 :json["data"].toDouble() ,
        status: json["status"],
      );

  Map<String, dynamic> toJson()=>{
    "message":message,
    "data":data,
    "status":status,
  };

}
