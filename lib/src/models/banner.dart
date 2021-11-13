class BannerList {
  bool success;
  List<Datas> data = <Datas>[];
  String message;

  BannerList({this.success, this.data, this.message});

  BannerList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(new Datas.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Datas {
  int id;
  String description;
  int restaurantId;
  int productId;
  String createdAt;
  String updatedAt;
  String type;
  String offer;
  List<Null> customFields;
  bool hasMedia;
  List<Media> media;

  Datas(
      {this.id,
        this.description,
        this.restaurantId,
        this.createdAt,
        this.updatedAt,
        this.type,
        this.customFields,
        this.hasMedia,
        this.media,
        this.productId,
        this.offer,
     });

  Datas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    restaurantId = json['restaurant_id'];
    productId = json['product_id'];
    // id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    offer = json["offer"];
    if (json['custom_fields'] != null) {
      customFields = new List();
      json['custom_fields'];
    }
    hasMedia = json['has_media'];
    if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['description'] = this.description;
    data['restaurant_id'] = this.restaurantId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type'] = this.type;
    data['offer'] = this.offer;
    if (this.customFields != null) {
      data['custom_fields'] = this.customFields;
    }
    data['has_media'] = this.hasMedia;
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  int id;
  String modelType;
  String modelId;
  String collectionName;
  String name;
  String fileName;
  String mimeType;
  String disk;
  String size;
  List<Null> manipulations;
  CustomProperties customProperties;
  List<Null> responsiveImages;
  String orderColumn;
  String createdAt;
  String updatedAt;
  String url;
  String thumb;
  String icon;
  String formatedSize;

  Media(
      {this.id,
        this.modelType,
        this.modelId,
        this.collectionName,
        this.name,
        this.fileName,
        this.mimeType,
        this.disk,
        this.size,
        this.manipulations,
        this.customProperties,
        this.responsiveImages,
        this.orderColumn,
        this.createdAt,
        this.updatedAt,
        this.url,
        this.thumb,
        this.icon,
        this.formatedSize});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelType = json['model_type'];
    modelId = json['model_id'];
    collectionName = json['collection_name'];
    name = json['name'];
    fileName = json['file_name'];
    mimeType = json['mime_type'];
    disk = json['disk'];
    size = json['size'];
    if (json['manipulations'] != null) {
      manipulations = new List();
      json['manipulations'];
    }
    customProperties = json['custom_properties'] != null
        ? new CustomProperties.fromJson(json['custom_properties'])
        : null;
    if (json['responsive_images'] != null) {
      responsiveImages = new List();
      json['responsive_images'];
    }
    orderColumn = json['order_column'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
    thumb = json['thumb'];
    icon = json['icon'];
    formatedSize = json['formated_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_type'] = this.modelType;
    data['model_id'] = this.modelId;
    data['collection_name'] = this.collectionName;
    data['name'] = this.name;
    data['file_name'] = this.fileName;
    data['mime_type'] = this.mimeType;
    data['disk'] = this.disk;
    data['size'] = this.size;
    if (this.manipulations != null) {
      data['manipulations'] =
          this.manipulations;
    }
    if (this.customProperties != null) {
      data['custom_properties'] = this.customProperties.toJson();
    }
    if (this.responsiveImages != null) {
      data['responsive_images'] =
          this.responsiveImages;
    }
    data['order_column'] = this.orderColumn;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['url'] = this.url;
    data['thumb'] = this.thumb;
    data['icon'] = this.icon;
    data['formated_size'] = this.formatedSize;
    return data;
  }
}

class CustomProperties {
  String uuid;
  int userId;
  GeneratedConversions generatedConversions;

  CustomProperties({this.uuid, this.userId, this.generatedConversions});

  CustomProperties.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    userId = json['user_id'];
    generatedConversions = json['generated_conversions'] != null
        ? new GeneratedConversions.fromJson(json['generated_conversions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['user_id'] = this.userId;
    if (this.generatedConversions != null) {
      data['generated_conversions'] = this.generatedConversions.toJson();
    }
    return data;
  }
}

class GeneratedConversions {
  bool thumb;
  bool icon;

  GeneratedConversions({this.thumb, this.icon});

  GeneratedConversions.fromJson(Map<String, dynamic> json) {
    thumb = json['thumb'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumb'] = this.thumb;
    data['icon'] = this.icon;
    return data;
  }
}