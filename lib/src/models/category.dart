import '../models/media.dart';

class CategoryList {
  List<CategoryData> categoryList;
  bool success;
  String message;
  CategoryList({this.categoryList, this.message, this.success});

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        message: json["message"],
        categoryList: json['data'] != null
            ? List.from(json['data'])
                .map((element) => CategoryData.fromJSON(element))
                .toList()
            : [],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": categoryList,
        "success": success,
      };
}

class CategoryData {
  List custom_fields;
  bool has_media;
  List<Media> media;
  int category_id;
  String restaurant;
  String category_name;
  String category_description;
  Category category;

  CategoryData(
      {this.category,
      this.category_id,
      this.media,
      this.custom_fields,
      this.has_media,
      this.category_name,
      this.category_description,
      this.restaurant});

  factory CategoryData.fromJSON(Map<String, dynamic> json) => CategoryData(
        category_id: json["category_id"],
        has_media: json["has_media"],
        restaurant: json["restaurant"],
        category_name: json["category_name"],
        category_description: json["category_description"],
        custom_fields: json["custom_fields"] != null
            ? List.from(json['data'])
                .map((element) => element.toString())
                .toList()
            : [],
        media: json["media"] != null
            ? List.from(json['data'])
                .map((element) => Media.fromJSON(element))
                .toList()
            : [],
        category: json["category"] != null
            ? Category.fromJSON(json["category"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "category_id": category_id,
        "has_media": has_media,
        "restaurant": restaurant,
        "category_name": category_name,
        "category_description": category_description,
        "custom_fields": custom_fields,
        "media": media,
        "category": category,
      };
}

class Category {
  String id;
  String name;
  Media image;
  String description;
  String created_at;
  String updated_at;
  String type;
  List custom_fields;
  bool has_media;

  Category();

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      description = jsonMap['description'];
      created_at = jsonMap['created_at'];
      updated_at = jsonMap['updated_at'];
      type = jsonMap['type'] == null ? null : jsonMap['type'];
      has_media = jsonMap['has_media'];
      custom_fields = jsonMap['custom_fields'];
    } catch (e) {
      id = '';
      name = '';
      description = '';
      created_at = '';
      updated_at = '';
      image = new Media();
      print(e);
    }
  }
}
