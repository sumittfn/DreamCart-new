class Enquiry {
  String restaurant_id;
  String user_id;
  String mobile;
  String decription;
  String name;

  Enquiry({
    this.mobile,
    this.user_id,
    this.decription,
    this.restaurant_id,
    this.name,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) =>
      Enquiry(
        mobile: json["mobile"],
        user_id: json["user_id"],
        decription: json["description"],
        restaurant_id: json["restaurant_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson()=>{
    "mobile" : mobile,
    "user_id" : user_id,
    "description" : decription,
    "restaurant_id" : restaurant_id,
    "name" : name,
  };

  // Map ofEnquiryToMap(Enquiry enquiry) {
  //   var map = this.Map();
  //   map["restaurant_id"] = enquiry.restaurant_id;
  //   return map;
  // }
}


