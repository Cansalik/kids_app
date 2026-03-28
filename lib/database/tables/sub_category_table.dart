import 'dart:convert';

class SubCategoryTable {
  int? subcategoryId;
  String? subcategoryName;
  String? subcategoryImage;


  SubCategoryTable({
    this.subcategoryId,
    this.subcategoryName,
    this.subcategoryImage,
  });

  factory SubCategoryTable.fromRawJson(String str) =>
      SubCategoryTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubCategoryTable.fromJson(Map<String, dynamic> json) =>
      SubCategoryTable(
        subcategoryId: json["sub_category_id"],
        subcategoryName: json["sub_category_name"],
        subcategoryImage: json["sub_category_image"],

      );

  Map<String, dynamic> toJson() => {
    "sub_category_id": subcategoryId,
    "sub_category_name": subcategoryImage,
    "sub_category_image": subcategoryImage,

  };
}
