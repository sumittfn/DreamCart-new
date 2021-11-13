import 'package:Dreamcart/src/models/address.dart';
import 'package:Dreamcart/src/models/cities.dart';
import 'package:Dreamcart/src/models/coupon.dart';

class RouteArgument {
  String id;
  String city_id;
  String heroTag;
  dynamic param;
  double amount;
  double current_amount;
  Address address;
  String product_id;
  String category_id;
  String promocode;
  double discount;
  List<Data> cityData;
  String city;
  Coupon coupon;
  double deliveryFee;
  List<Coupon> coupons;
  String discountType;
  String status;

  RouteArgument(
      {this.id,
      this.heroTag,
      this.param,
      this.amount,
      this.current_amount,
      this.address,
      this.city_id,
      this.product_id,
      this.category_id,
      this.discount,
      this.promocode,
      this.coupon,
      this.cityData,
      this.city,
      this.coupons,
      this.deliveryFee,
      this.discountType,
      this.status});

  @override
  String toString() {
    return '{id: $id, city_id: $city_id, heroTag:${heroTag.toString()},product_id:$product_id,category_id:$category_id,promocode:$promocode,discount:$discount, cityData:$cityData, city:$city, coupon:$coupon,address:$address,deliveryFee:$deliveryFee, coupons:$coupons,discountType:$discountType, status:$status}';
  }
}
