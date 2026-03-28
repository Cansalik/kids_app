import 'dart:convert';

class PaintTable {
  int? categoryId;
  int? itemId;
  String? itemName;
  String? itemImage;


  PaintTable({
    this.categoryId,
    this.itemId,
    this.itemName,
    this.itemImage,
  });

  factory PaintTable.fromRawJson(String str) =>
      PaintTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaintTable.fromJson(Map<String, dynamic> json) =>
      PaintTable(
        categoryId: json["category_id"],
        itemId: json["item_id"],
        itemName: json["item_name"],
        itemImage: json["item_image"],

      );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "item_id": itemId,
    "item_name": itemName,
    "item_image": itemImage,

  };
}
