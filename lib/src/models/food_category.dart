class FoodCategory {
  bool status;
  List<FoodwiseCategory> food_wise_ategory;
  String message;

  FoodCategory({this.status, this.food_wise_ategory, this.message});

  factory FoodCategory.fromJosn(Map<String, dynamic> json) {
    FoodCategory(
      status: json["status"] == null ? null : json["status"],
      food_wise_ategory: json["food_wise_ategory"] == null
          ? null
          : List.from(json['food_wise_ategory'])
              .map((element) => FoodwiseCategory.fromJson(element))
              .toList(),
      message: json["message"] == null ? null : json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "food_wise_ategory": food_wise_ategory,
        "message": message,
      };
}

class FoodwiseCategory {
  String category_id;
  String category_name;
  String category_description;
  List custom_fields;
  bool has_media;
  String restaurant;
  Category category;
  List media;

  FoodwiseCategory(
      {this.category,
      this.restaurant,
      this.category_description,
      this.category_id,
      this.category_name,
      this.custom_fields,
      this.has_media,
      this.media});

  factory FoodwiseCategory.fromJson(Map<String, dynamic> json) {
    FoodwiseCategory(
      category: json["category"] == null ? null : json["category"],
      restaurant: json["restaurant"] == null ? null : json["restaurant"],
      category_description: json["category_description"] == null
          ? null
          : json["category_description"],
      category_id: json["category_id"] == null ? null : json["category_id"],
      category_name:
          json["category_name"] == null ? null : json["category_name"],
      custom_fields:
          json["custom_fields"] == null ? null : json["custom_fields"],
      has_media: json["has_media"] == null ? null : json["has_media"],
      media: json["media"] == null ? null : json["media"],
    );
  }

  Map<String, dynamic> toJos() => {
        "category": category,
        "restaurant": restaurant,
        "category_description": category_description,
        "category_id": category_id,
        "category_name": category_name,
        "category_name": category_name,
        "custom_fields": custom_fields,
        "has_media": has_media,
        "media": media,
      };
}

class Category {
  String id;
  String name;
  String description;
  String created_at;
  String updated_at;

  Category(
      {this.id, this.name, this.description, this.created_at, this.updated_at});

  factory Category.fromJson(Map<String, dynamic> json) {
    Category(
      id: json["id"] == null ? null : json["id"],
      created_at: json["created_at"] == null ? null : json["created_at"],
      description: json["description"] == null ? null : json["description"],
      name: json["name"] == null ? null : json["name"],
      updated_at: json["updated_at"] == null ? null : json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": created_at,
        "description": description,
        "name": name,
        "updated_at": updated_at,
      };
}
