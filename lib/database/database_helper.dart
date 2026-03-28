import 'package:flutter/services.dart';
import 'package:kids_playroom/database/tables/alphabets_table.dart';
import 'package:kids_playroom/database/tables/drag_item_table.dart';
import 'package:kids_playroom/database/tables/item_table.dart';
import 'package:kids_playroom/database/tables/paint_table.dart';
import 'package:kids_playroom/database/tables/sub_category_table.dart';
import 'package:kids_playroom/database/tables/vide_table.dart';

import 'package:path/path.dart' as path;
import 'dart:io' as io;

import 'package:sqflite/sqflite.dart';
import 'tables/category_table.dart';
import 'tables/spelling_table.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper.internal();

  factory DataBaseHelper() => instance;

  Database? _db;

  DataBaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  init() async {
    var dbPath = await getDatabasesPath();

    String dbPathKidsAllInOne = path.join(dbPath, "KidsPlayroom.db");

    bool dbExistsEnliven = await io.File(dbPathKidsAllInOne).exists();

    if (!dbExistsEnliven) {
      ByteData data = await rootBundle
          .load(path.join("assets/database", "KidsPlayroom.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await io.File(dbPathKidsAllInOne).writeAsBytes(bytes, flush: true);
    }

    return _db = await openDatabase(dbPathKidsAllInOne);
  }

  String categoryTable = "CategoryTable";
  String dragCategoryTable = "DragCategoryTable";
  String subcategoryTable = "SubCategoryTable";
  String kidVideoTable = "KidsVideoTable";

  String itemTable = "ItemTable";
  String dragItemTable = "DragItemsTable";
  String paintTable = "PaintTable";
  String quizTable = "QuizTable";
  String alphabetsTable = "DragAlphabetsTable";
  String spellingTable = "DragSpellingTable";
  String subCategoryName = "sub_category_name";
  String dragSubCategoryName = "category_name";

  Future<List<CategoryTable>> getCategoryData() async {
    List<CategoryTable> categoryList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $categoryTable");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var categoryData = CategoryTable.fromJson(answer);
        categoryList.add(categoryData);
      }
    }

    return categoryList;
  }

  Future<List<SubCategoryTable>> getSubCategoryData() async {
    List<SubCategoryTable> subcategoryList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM $subcategoryTable ORDER BY $subCategoryName ASC");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var categoryData = SubCategoryTable.fromJson(answer);
        subcategoryList.add(categoryData);
      }
    }

    return subcategoryList;
  }

  Future<List<ItemTable>> getItemData(int subcategoryId) async {
    List<ItemTable> itemList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM $itemTable where sub_category_id = $subcategoryId");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var itemData = ItemTable.fromJson(answer);
        itemList.add(itemData);
      }
    }

    return itemList;
  }

  Future<List<PaintTable>> getPaintData() async {
    List<PaintTable> paintList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $paintTable");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var paintData = PaintTable.fromJson(answer);
        paintList.add(paintData);
        print(":::::::${paintList[0].itemImage}");
      }
    }
    return paintList;
  }

  Future<List<CategoryTable>> getDragCategoryData() async {
    List<CategoryTable> dragCategoryList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $dragCategoryTable");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var categoryData = CategoryTable.fromJson(answer);
        dragCategoryList.add(categoryData);
      }
    }

    return dragCategoryList;
  }

  Future<List<DragItemTable>> getDragItemData(int subcategoryId) async {
    List<DragItemTable> itemList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM $dragItemTable where category_id = $subcategoryId");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var itemData = DragItemTable.fromJson(answer);
        itemList.add(itemData);
      }
    }

    return itemList;
  }

  Future<List<AlphabetsTable>> getAlphabetsData() async {
    List<AlphabetsTable> alphabetsList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $alphabetsTable");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var alphabetsData = AlphabetsTable.fromJson(answer);
        alphabetsList.add(alphabetsData);
      }
    }
    return alphabetsList;
  }

  Future<List<SpellingTable>> getSpellingData() async {
    List<SpellingTable> spellList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $spellingTable");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var spellData = SpellingTable.fromJson(answer);
        spellList.add(spellData);
      }
    }
    return spellList;
  }

  Future<List<VideoTable>> getVideo(int catId) async {
    List<VideoTable> videosList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient
        .rawQuery("SELECT * FROM $kidVideoTable  WHERE id = $catId");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var videoData = VideoTable.fromJson(answer);
        videosList.add(videoData);
      }

    }
    return videosList;
  }
}
