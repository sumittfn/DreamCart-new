import 'package:Dreamcart/src/models/coupon.dart';

class Coupons {
  bool success;
  List<Coupon> coupons;
  String message;

  Coupons({this.message, this.success,this.coupons});

  factory Coupons.fromJson(Map<String, dynamic> json) =>
      Coupons(
        success: json["success"],
        message: json["message"].toString(),
        coupons: json["data"] == null ? [] :  List.from(json['data'])
            .map((element) => Coupon.fromJSON(element))
            .toList(),
      );

  Map<String, dynamic> toJson()=> {
    "success":success,
    "message":message,
    "data" : coupons
  };
}