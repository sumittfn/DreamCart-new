import 'dart:convert';
import 'dart:io';

import 'package:Dreamcart/src/models/cities.dart';
import 'package:Dreamcart/src/models/enquiry.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/filter.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../repository/user_repository.dart';

Future<Stream<Restaurant>> getNearRestaurants(
    Address myLocation, Address areaLocation, String city_id) async {
  Uri uri = Helper.getUri('api/restaurants');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['city'] = '$city_id';
  _queryParams['limit'] = '6';

  if (!myLocation.isUnknown() && !areaLocation.isUnknown()) {
    _queryParams['myLon'] = myLocation.longitude.toString();
    _queryParams['myLat'] = myLocation.latitude.toString();
    _queryParams['areaLon'] = areaLocation.longitude.toString();
    _queryParams['areaLat'] = areaLocation.latitude.toString();
  }
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      print("Restaurant Data :::::::::::::::::::::>>>>>>>>>>> " +
          data.toString());
      return Restaurant.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> getPopularRestaurants(
    Address myLocation, String city_id) async {
  // Uri uri = Helper.getUri('api/restaurants');
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurants?limit=6&popular=all&city=$city_id';
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['limit'] = '6';
  _queryParams['popular'] = 'all';
  _queryParams['city'] = '$city_id';
  if (!myLocation.isUnknown()) {
    _queryParams['myLon'] = myLocation.longitude.toString();
    _queryParams['myLat'] = myLocation.latitude.toString();
  }
  // _queryParams.addAll(filter.toQuery());
  // uri = uri.replace(queryParameters: _queryParams);
  print("URI :::::::::::::: top restaurants:::::>>>>> " + url.toString());
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Restaurant.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url.toString()).toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> searchRestaurants(
    String search, Address address) async {
  Uri uri = Helper.getUri('api/restaurants');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = 'name:$search;description:$search';
  _queryParams['searchFields'] = 'name:like;description:like';
  _queryParams['limit'] = '5';
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Restaurant.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> getRestaurant(String id, Address address) async {
  Uri uri = Helper.getUri('api/restaurants/$id');
  Map<String, dynamic> _queryParams = {};
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) => Restaurant.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<void> addEnquiry(
    {String restaurant_id,
    String description,
    String username,
    String mobile,
    String user_id}) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_enquiry';
  final client = new http.Client();
  Enquiry enquiry = Enquiry(
    mobile: mobile,
    decription: description,
    restaurant_id: restaurant_id,
    user_id: user_id,
    name: username,
  );

  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(enquiry),
    );
    if (response.statusCode == 200) {
      return print(response.body);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return print(response.body);
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return print(url.toString());
  }
}

Future<Stream<Data>> getCitiesList() async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}cities';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      print(
          "City Data :::::::::::::::::::::::::::::::>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> " +
              data.toString());
      return Data.fromJson(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Data.fromJson({}));
  }
}

Future<Stream<Restaurant>> getRestaurantList(String id) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurants?category_id:$id';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Restaurant.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Review>> getRestaurantReviews(String id) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_reviews?with=user&search=restaurant_id:$id';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Review.fromJSON({}));
  }
}

Future<Stream<Review>> getRecentReviews() async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_reviews?orderBy=updated_at&sortedBy=desc&limit=3&with=user';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Review.fromJSON({}));
  }
}

Future<Stream<DriverReview>> getDriverReviews() async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}driver_reviews?orderBy=updated_at&sortedBy=desc&limit=3&with=user';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return DriverReview.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new DriverReview.fromJSON({}));
  }
}

Future<Review> addRestaurantReview(Review review, Restaurant restaurant) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}restaurant_reviews';
  final client = new http.Client();
  review.user = currentUser.value;
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofRestaurantToMap(restaurant)),
    );
    if (response.statusCode == 200) {
      return Review.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return Review.fromJSON({});
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Review.fromJSON({});
  }
}

Future<DriverReview> addDriverReview(
    DriverReview review, String driver_id) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}driver_reviews';
  final client = new http.Client();
  review.user = currentUser.value;
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofDriverToMap(driver_id)),
    );
    print("Driver Id :::::::::::::>>>>>>>> " +
        review.ofDriverToMap(driver_id).toString());
    if (response.statusCode == 200) {
      print("Response Body :::::::::::::::::>>>>>>>>>>> " +
          response.body.toString());
      return DriverReview.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return DriverReview.fromJSON({});
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return DriverReview.fromJSON({});
  }
}
