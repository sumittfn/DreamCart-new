import '../models/category.dart';
import '../models/extra.dart';
import '../models/extra_group.dart';
import '../models/media.dart';
import '../models/nutrition.dart';
import '../models/restaurant.dart';
import '../models/review.dart';

class Food {
  String id;
  String name;
  double price;
  double discountPrice;
  Media image;
  String description;
  String ingredients;
  String weight;
  String unit;
  String packageItemsCount;
  bool featured;
  bool deliverable;
  Restaurant restaurant;
  Category category;
  List<Extra> extras;
  List<ExtraGroup> extraGroups;
  List<Review> foodReviews;
  List<Nutrition> nutritions;
  String veg;
  int city;
  String in_stock;
  int restaurant_id;
  int category_id;
  String cerated_at;
  String updated_at;
  bool has_media;

  Food();

  Food.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      veg = jsonMap['veg'];
      city = jsonMap['city'];
      in_stock = jsonMap['in_stock'];
      restaurant_id = jsonMap['restaurant_id'];
      category_id = jsonMap['category_id'];
      cerated_at = jsonMap['cerated_at'];
      updated_at = jsonMap['updated_at'];
      has_media = jsonMap['has_media'];
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      discountPrice = jsonMap['discount_price'] != null
          ? jsonMap['discount_price'].toDouble()
          : 0.0;
      price = discountPrice != 0 ? discountPrice : price;
      discountPrice = discountPrice == 0
          ? discountPrice
          : jsonMap['price'] != null
              ? jsonMap['price'].toDouble()
              : 0.0;
      description = jsonMap['description'];
      ingredients = jsonMap['ingredients'];
      weight = jsonMap['weight'] != null ? jsonMap['weight'].toString() : '';
      unit = jsonMap['unit'].toString();
      packageItemsCount = jsonMap['package_items_count'].toString();
      featured = jsonMap['featured'] ?? false;
      deliverable = jsonMap['deliverable'] ?? false;
      restaurant = jsonMap['restaurant'] != null
          ? Restaurant.fromJSON(jsonMap['restaurant'])
          : null;
      category = jsonMap['category'] != null
          ? Category.fromJSON(jsonMap['category'])
          : new Category();
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      extras =
          jsonMap['extras'] != null && (jsonMap['extras'] as List).length > 0
              ? List.from(jsonMap['extras'])
                  .map((element) => Extra.fromJSON(element))
                  .toList()
              : [];
      extraGroups = jsonMap['extra_groups'] != null &&
              (jsonMap['extra_groups'] as List).length > 0
          ? List.from(jsonMap['extra_groups'])
              .map((element) => ExtraGroup.fromJSON(element))
              .toList()
          : [];
      foodReviews = jsonMap['food_reviews'] != null &&
              (jsonMap['food_reviews'] as List).length > 0
          ? List.from(jsonMap['food_reviews'])
              .map((element) => Review.fromJSON(element))
              .toList()
          : [];
      nutritions = jsonMap['nutrition'] != null &&
              (jsonMap['nutrition'] as List).length > 0
          ? List.from(jsonMap['nutrition'])
              .map((element) => Nutrition.fromJSON(element))
              .toList()
          : [];
    } catch (e) {
      id = '';
      name = '';
      // veg = 0;
      city = 0;
      // in_stock = 0;
      restaurant_id = 0;
      category_id = 0;
      cerated_at = '';
      updated_at = '';
      has_media = false;
      price = 0.0;
      discountPrice = 0.0;
      description = '';
      weight = '';
      ingredients = '';
      unit = '';
      packageItemsCount = '';
      featured = false;
      deliverable = false;
      restaurant = new Restaurant();
      category = new Category();
      image = new Media();
      extras = [];
      extraGroups = [];
      foodReviews = [];
      nutritions = [];
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["veg"] = veg;
    map["city"] = city;
    map["in_stock"] = in_stock;
    map["restaurant_id"] = restaurant_id;
    map["category_id"] = category_id;
    map["cerated_at"] = cerated_at;
    map["updated_at"] = updated_at;
    map["has_media"] = has_media;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["ingredients"] = ingredients;
    map["weight"] = weight;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }
}
