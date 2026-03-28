import 'dart:convert';

class ItemTable {
  int? categoryId;
  int? itemId;
  String? itemName;
  String? itemNameTts;
  String? itemImage;


  ItemTable({
    this.categoryId,
    this.itemId,
    this.itemName,
    this.itemNameTts,
    this.itemImage,
  });

  factory ItemTable.fromRawJson(String str) =>
      ItemTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemTable.fromJson(Map<String, dynamic> json) =>
      ItemTable(
        categoryId: json["category_id"],
        itemId: json["item_id"],
        itemName: json["item_name"],
        itemNameTts: json["item_name_tts"],
        itemImage: json["item_image"],

      );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "item_id": itemId,
    "item_name": itemName,
    "item_name_tts": itemNameTts,
    "item_image": itemImage,

  };
}
