import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Cart>> getCart() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts?${_apiToken}with=food;food.restaurant;extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  print("Listen Cart Url ::::::::::::::::>>>>>>>>>>>>>" + url);
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Cart.fromJSON(data);
  });
}

Future<Stream<int>> getCartCount() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(0);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts/count?${_apiToken}search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map(
        (data) => Helper.getIntData(data),
      );
}

Future<Cart> addCart(Cart cart) async {
  Map<String, dynamic> decodedJSON = {};

  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts/stores';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  print("Cart Details ::::::::: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" +
      cart.toMap().toString());
  // print("Cart Url :::::::::::::::::>>>>>>>>>> " + url.toString());
  try {
    decodedJSON = json.decode(response.body)['data'] as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }
  return Cart.fromJSON(decodedJSON);
}

// Future<Stream<DeliveryFee>> deliveryFees(double amount, String city_id, String restaurant_id) async {
//
//
//   final String url =
//       '${GlobalConfiguration().getString('api_base_url')}deliverycharges?city=$city_id&amount=$amount&restaurant_id=$restaurant_id';
//   final client = new http.Client();
//
//   try {
//     final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
//     return streamedRest.stream
//         .transform(utf8.decoder)
//         .transform(json.decoder)
//         .map((data) => Helper.getData(data))
//         .expand((data) => (data as List))
//         .map((data) {
//       return DeliveryFee.fromJson(data);
//     });
//     // decodedJSON = json.decode(response.body)['data'] as Map<String, dynamic>;
//   } on FormatException catch (e) {
//     print(e);
//   }
//
// }

Future<Stream<DeliveryFee>> deliveryFees(
    double amount, String city_id, String restaurant_id) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}deliverycharges?city=$city_id&amount=$amount&restaurant_id=$restaurant_id';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  print("Delivery Url :::::::::::::::::::::>>>>>>>>>>>>>>>>>> " + url);

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map(
    (data) {
      return DeliveryFee.fromJson(data);
    },
  );
}

Future<Cart> updateCart(Cart cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Cart();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  cart.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  return Cart.fromJSON(json.decode(response.body)['data']);
}

Future<bool> removeCart(Cart cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return false;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Helper.getBoolData(json.decode(response.body));
}
