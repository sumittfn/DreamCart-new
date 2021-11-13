import '../models/food.dart';
import '../models/restaurant.dart';
import '../models/user.dart';

class Review {
  String id;
  String review;
  String rate;
  User user;

  Review();
  Review.init(this.rate);

  Review.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      review = jsonMap['review'] != null ? jsonMap['review'] : null;
      rate = jsonMap['rate'].toString() ?? '0';
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : null;
    } catch (e) {
      id = '';
      review = '';
      rate = '0';
      user = new User();
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["review"] = review;
    map["rate"] = rate;
    map["user_id"] = user?.id;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  Map ofRestaurantToMap(Restaurant restaurant) {
    var map = this.toMap();
    map["restaurant_id"] = restaurant.id;
    return map;
  }

  Map ofDriverToMap(String driver_id){
    var map = this.toMap();
    map[driver_id] = driver_id;
    return map;
  }

  Map ofFoodToMap(Food food) {
    var map = this.toMap();
    map["food_id"] = food.id;
    return map;
  }
}

class DriverReview {
  String id;
  String review;
  String rate;
  User user;
  String driver_id;

  DriverReview();
  DriverReview.init(this.rate);

  DriverReview.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      review = jsonMap['review'] != null ? jsonMap['review'] : null;
      rate = jsonMap['rate'].toString() ?? '0';
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : null;
      driver_id = jsonMap['driver_id'].toString();
    } catch (e) {
      id = '';
      driver_id = '';
      review = '';
      rate = '0';
      user = new User();
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["review"] = review;
    map["rate"] = rate;
    map["user_id"] = user?.id;
    map["driver_id"] = driver_id;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  Map ofDriverToMap(String driver_id){
    var map = this.toMap();
    map[driver_id] = driver_id;
    return map;
  }

}
