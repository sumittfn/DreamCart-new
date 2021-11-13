import 'discountable.dart';

class Coupon {
  String id;
  String code;
  double discount;
  String discountType;
  List<Discountable> discountables;
  String discountableId;
  bool enabled;
  String description;
  String expries_at;
  String created_at;
  String updated_at;
  bool valid;

  Coupon();

  Coupon.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      code = jsonMap['code'] != null ? jsonMap['code'].toString() : '';
      description = jsonMap['description'] != null
          ? jsonMap['description'].toString()
          : '';
      discount =
          jsonMap['discount'] != null ? jsonMap['discount'].toDouble() : 0.0;
      discountType = jsonMap['discount_type'] != null
          ? jsonMap['discount_type'].toString()
          : null;
      discountables = jsonMap['discountables'] != null
          ? List.from(jsonMap['discountables'])
              .map((element) => Discountable.fromJSON(element))
              .toList()
          : [];
      expries_at =
          jsonMap['expries_at'] != null ? jsonMap['expries_at'].toString() : '';
      created_at =
          jsonMap['created_at'] != null ? jsonMap['created_at'].toString() : '';
      updated_at =
          jsonMap['updated_at'] != null ? jsonMap['updated_at'].toString() : '';
      valid = jsonMap['valid'];
    } catch (e) {
      id = '';
      code = '';
      discount = 0.0;
      discountType = '';
      discountables = [];
      // valid = null;
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["code"] = code;
    map["discount"] = discount;
    map["discount_type"] = discountType;
    map["description"] = description;
    map["valid"] = valid;
    map["expries_at"] = expries_at;
    map["created_at"] = created_at;
    map["updated_at"] = updated_at;
    map["discountables"] =
        discountables.map((element) => element.toMap()).toList();

    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
