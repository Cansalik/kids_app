import 'dart:convert';

class DragItemTable {
  int? categoryId;
  int? itemId;
  String? itemName;
  String? itemImage;


  DragItemTable({
    this.categoryId,
    this.itemId,
    this.itemName,
    this.itemImage,
  });

  factory DragItemTable.fromRawJson(String str) =>
      DragItemTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DragItemTable.fromJson(Map<String, dynamic> json) =>
      DragItemTable(
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
