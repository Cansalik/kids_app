import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/database/database_helper.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class PaintController extends GetxController {
  List? itemList = [];

  bool isColorSelected = false;
  bool isEraserSelected = false;
  bool isRestartSelected = false;
  bool isRestartShow = false;
  bool isSaveSelected = false;
  bool isImagesSelected = false;

  Color? prevColor;
  Color? currentColor = AppColor.first;

  String currentImage = "item/1.webp";
  int? currentIndex = 0;
  Color? colur;

  String? path;
  Uint8List? pngBytes;

  FlutterTts flutterTts = FlutterTts();

  dynamic args = Get.arguments;
  String? title;
  int? subId;

  @override
  void onInit() {
    getDataFromArgs();
    getDataFromDatabase();
    super.onInit();
  }

  getDataFromArgs() {
    if (args != null) {
      if (args[0] != null) {
        title = args[0];
      }
      if (args[1] != null) {
        subId = args[1];
      }
    }
  }

  getDataFromDatabase() async {
    itemList = await DataBaseHelper().getPaintData();
  }

  createImageFile(String currentImage) async {
    var bytes = await rootBundle.load("assets/$currentImage");
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fullPath = '$dir/${DateTime.now().millisecond}.png';
    File capturedFile = File(fullPath);
    pngBytes = bytes.buffer.asUint8List();
    if (pngBytes != null) {
      await capturedFile.writeAsBytes(pngBytes!);
      path = capturedFile.path;
    }
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }

  colorPicker(int index) {
    currentColor = Utils.colorPickerList[index];
    isColorSelected = false;
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }

  imagePicker(int index) {
    currentIndex = index;
    currentImage = "${itemList![index].itemImage}" ".webp";
    isImagesSelected = false;
    createImageFile(currentImage);
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }

  selectImageOption() {
    isImagesSelected = !isImagesSelected;
    isColorSelected = false;
    isEraserSelected = false;
    isRestartSelected = false;
    isSaveSelected = false;
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }

  saveOption() {
    isSaveSelected = !isSaveSelected;
    isColorSelected = false;
    isEraserSelected = false;
    isRestartSelected = false;
    isImagesSelected = false;
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }

  eraserOption() {
    isEraserSelected = !isEraserSelected;
    isColorSelected = false;
    isRestartSelected = false;
    isSaveSelected = false;
    isImagesSelected = false;
    if (isEraserSelected) {
      prevColor = currentColor;
      currentColor = AppColor.white;
    } else {
      currentColor = prevColor;
    }
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }

  colorOption() {
    isColorSelected = !isColorSelected;
    isEraserSelected = false;
    isRestartSelected = false;
    isSaveSelected = false;
    isImagesSelected = false;
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }

  onColorPickerDialogColorChanged(value) {
    colur = value;
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }

  onColorPickerDialogCancel() {
    isColorSelected = false;
    Get.back();
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }

  onColorPickerDialogOk() {
    if (colur != null) {
      currentColor = colur!;
    }
    isColorSelected = false;
    Get.back();
    update();
  }

  onSaveDialogNo() {
    isSaveSelected = false;
    Get.back();
    update();
  }

  onSaveDialogYes(context) async {
    if (pngBytes != null && path != null) {
      Directory generalDownloadDir = Platform.isIOS ? await getApplicationDocumentsDirectory() : Directory('/storage/emulated/0/Download');
      String path = generalDownloadDir.path;
      File file = File('$path/${"txtAppName".tr}_${DateTime.now().millisecondsSinceEpoch}.png');
      print(file.path);
      await file.writeAsBytes(pngBytes!, flush: true);
      Utils.showToast(context, "txtImageSaved".tr);
      // await GallerySaver.saveImage(path!,
      //     albumName: "txtAppName".tr)
      //     .then((value) {
      //      Utils.showToast(context, "txtImageSaved".tr);
      //  });
    }
    isSaveSelected = false;
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }

  onRestartDialogNo() {
    isRestartSelected = false;
    Get.back();
    update();
  }

  onRestartDialogYes(context) {
    isRestartSelected = true;
    isColorSelected = false;
    isEraserSelected = false;
    isSaveSelected = false;
    isImagesSelected = false;
    currentImage = "";

    Future.delayed(const Duration(milliseconds: 15), () {
      currentImage = "${itemList![currentIndex!].itemImage}.webp";
      isRestartSelected = false;
      createImageFile(currentImage);
    });
    Get.back();
    update([
      Constant.idSaveOption,
      Constant.idImagePicker,
      Constant.idSaveOption,
      Constant.idColorOption,
      Constant.idSelectImageOption,
      Constant.idEraserOption,
      Constant.idPaintWidget
    ]);
  }
}
