import 'dart:convert';

// class Cities {
//   bool success;
//   List<Data> data;
//   String message;
//
//   Cities({this.message, this.data, this.success});
//
//   factory Cities.fromJson(Map<String, dynamic> json) => Cities(
//         data: json["data"] == null
//             ? null
//             : List.from(json['data'])
//                 .map((element) => Data.fromJson(element))
//                 .toList(),
//         message: json["message"] == null ? null : json["message"],
//       );
// }

class Data {
  int id;
  String name;
  String description;
  String created_at;
  String updated_at;
  List custom_fields;
  List restaurants;
  String fromTime;
  String toTime;
  String type;

  Data({
    this.name,
    this.id,
    this.custom_fields,
    this.updated_at,
    this.created_at,
    this.description,
    this.restaurants,
    this.fromTime,
    this.toTime,
    this.type
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      updated_at: json["updated_at"] == null ? null : json["updated_at"],
      name: json["name"] == null ? null : json["name"],
      description: json["description"] == null ? null : json["description"],
      created_at: json["created_at"] == null ? null : json["created_at"],
      fromTime: json["from_time"] == null ? null : json["from_time"],
      toTime: json["to_time"] == null ? null : json["to_time"],
      type: json["type"] == null ? null : json["type"],
      id: json["id"] == null ? 0 : json["id"],
      custom_fields: json["custom_fields"] == null
          ? null
          : List.from(json["custom_fields"]).map((e) => e).toList(),
  restaurants:json["restaurants"] == null
      ? null
      : List.from(json["restaurants"]).map((e) => e).toList(), );


  Map<String, dynamic> toJson()=>{
    "name":name,
    "fromTime":fromTime,
    "toTime":toTime,
    "type":type,
    "updated_at":updated_at,
    "description":description,
    "created_at":created_at,
    "id":id,
    "custom_fields":custom_fields,
    "restaurants":restaurants,
  };
}
