import 'dart:io';
import 'dart:ui' as ui;

import 'package:floodfill_image/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/ui/paint/controllers/paint_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path_provider/path_provider.dart';

class PaintScreen extends StatelessWidget {
  const PaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.colorTheme,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Constant.getAssetIcons() + "btn_back_150.png", width: AppSizes.height_4_5),
          ),
        ),
        title: GetBuilder<PaintController>(builder: (logic) {
          return Text(
            logic.title.toString().tr,
            style: TextStyle(color: AppColor.colorGreen, fontSize: AppFontSize.size_16, fontWeight: FontWeight.bold, fontFamily: "UrbanistBlack"),
          );
        }),
      ),
      backgroundColor: AppColor.lightBG,
      body: SafeArea(
        top: false,
        bottom: true,
        child: GetBuilder<PaintController>(
            id: Constant.idPaintWidget,
            builder: (logic) {
              return Column(
                children: [
                  _paintWidget(context),
                  _optionsWidget(context),
                ],
              );
            }),
      ),
    );
  }
}

topBar() {
  return GetBuilder<PaintController>(builder: (logic) {
    return Container(
      width: AppSizes.fullWidth,
      color: AppColor.colorTheme,
      padding: EdgeInsets.only(
        left: AppSizes.width_3,
        top: AppSizes.height_5,
        bottom: AppSizes.height_1,
      ),
      child: Center(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Image.asset(Constant.getAssetIcons() + "btn_back_150.png", height: AppSizes.height_5),
            ),
            Center(
              child: Text(
                logic.title.toString().tr,
                style: TextStyle(color: AppColor.colorGreen, fontSize: AppFontSize.size_16, fontWeight: FontWeight.bold, fontFamily: "UrbanistBlack"),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

_paintWidget(BuildContext context) {
  return Expanded(
    child: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/background/bg_paint.webp"), fit: BoxFit.fill),
      ),
      child: Column(
        children: [
          // (_isBottomBannerAdLoaded)
          //     ? SizedBox(
          //   height: _bottomBannerAd.size.height.toDouble(),
          //   width: _bottomBannerAd.size.width.toDouble(),
          //   child: AdWidget(ad: _bottomBannerAd),
          // )
          //     : Container(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    _colorImageFloodFill(),
                    SizedBox(
                      height: AppSizes.height_3,
                    ),
                    _colorPicker(context),
                    _imagePicker()
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

_colorImageFloodFill() {
  return GetBuilder<PaintController>(builder: (logic) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: FloodFillImage(
        height: AppSizes.height_44.toInt(),
        imageProvider: AssetImage("assets/${logic.currentImage}"),
        fillColor: logic.currentColor!,
        avoidColor: const [Colors.transparent, Colors.black],
        onFloodFillStart: (position, image) {
          logic.isRestartShow = true;
          logic.update();
        },
        tolerance: 8,
        onFloodFillEnd: (value) async {
          final ByteData? byteData = await value.toByteData(format: ui.ImageByteFormat.png);
          logic.pngBytes = byteData!.buffer.asUint8List();
          final String dir = (await getApplicationDocumentsDirectory()).path;
          final String fullPath = '$dir/${DateTime.now().millisecond}.png';
          File capturedFile = File(fullPath);
          if (logic.pngBytes != null) {
            await capturedFile.writeAsBytes(logic.pngBytes!);
            logic.path = capturedFile.path;
          }
        },
      ),
    );
  });
}

_colorPicker(BuildContext context) {
  return GetBuilder<PaintController>(
      id: Constant.idColorPicker,
      builder: (logic) {
        return Visibility(
          visible: logic.isColorSelected,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 100,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppColor.themeGradient),
                borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
            child: Row(
              children: [
                Expanded(
                    child: Center(
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Utils.colorPickerList.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.9, crossAxisSpacing: AppFontSize.size_1),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () => logic.colorPicker(index),
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Utils.colorPickerList[index], shape: BoxShape.circle, border: Border.all(color: AppColor.white, width: 2)),
                          ),
                        );
                      }),
                )),
                InkWell(
                  onTap: () {
                    _colorPickerDialog(context);
                  },
                  child: Image.asset(
                    "assets/icons/ic_color_picker.webp",
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

_imagePicker() {
  return GetBuilder<PaintController>(
      id: Constant.idImagePicker,
      builder: (logic) {
        return Visibility(
          visible: logic.isImagesSelected,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 100,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppColor.themeGradient),
                borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
            child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: logic.itemList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.55,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => logic.imagePicker(index),
                    child: Image.asset("assets/${logic.itemList![index].itemImage}.webp"),
                  );
                }),
          ),
        );
      });
}

_optionsWidget(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: AppColor.colorTheme,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _colorOption(),
        _eraserOption(),
        _restartOption(context),
        _saveOption(context),
        _selectImageOption(),
      ],
    ),
  );
}

_selectImageOption() {
  return GetBuilder<PaintController>(builder: (logic) {
    return InkWell(
      onTap: () => logic.selectImageOption(),
      child: Container(
        margin: EdgeInsets.only(top: logic.isImagesSelected ? 20 : 30),
        height: logic.isImagesSelected ? 90 : 80,
        width: 55,
        decoration: BoxDecoration(
            color: logic.isImagesSelected ? AppColor.colorGreen : AppColor.green,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
            boxShadow: [BoxShadow(blurRadius: 6, color: AppColor.black.withValues(alpha: 0.5))]),
        child: Image.asset(
          "assets/icons/ic_images.webp",
          height: 20,
          width: 20,
        ),
      ),
    );
  });
}

_saveOption(BuildContext context) {
  return GetBuilder<PaintController>(
      id: Constant.idSaveOption,
      builder: (logic) {
        return InkWell(
          onTap: () async {
            logic.saveOption();
            _saveDialog(context);
          },
          child: Container(
            margin: EdgeInsets.only(top: logic.isSaveSelected ? 20 : 30),
            height: logic.isSaveSelected ? 90 : 80,
            width: 55,
            decoration: BoxDecoration(
                color: logic.isSaveSelected ? AppColor.colorGreen : AppColor.green,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                boxShadow: [BoxShadow(blurRadius: 6, color: AppColor.black.withValues(alpha: 0.5))]),
            child: Image.asset(
              "assets/icons/ic_save.webp",
              height: 20,
              width: 20,
            ),
          ),
        );
      });
}

_restartOption(BuildContext context) {
  return GetBuilder<PaintController>(builder: (logic) {
    return Visibility(
      visible: logic.isRestartShow,
      child: InkWell(
        onTap: () {
          _restartDialog(context);
        },
        child: Container(
          margin: EdgeInsets.only(top: logic.isRestartSelected ? 20 : 30),
          height: logic.isRestartSelected ? 90 : 80,
          width: 55,
          decoration: BoxDecoration(
              color: logic.isRestartSelected ? AppColor.colorGreen : AppColor.green,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
              boxShadow: [BoxShadow(blurRadius: 6, color: AppColor.black.withValues(alpha: 0.5))]),
          child: Image.asset(
            "assets/icons/ic_restart.webp",
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  });
}

_eraserOption() {
  return GetBuilder<PaintController>(builder: (logic) {
    return InkWell(
      onTap: () => logic.eraserOption(),
      child: Container(
        margin: EdgeInsets.only(top: logic.isEraserSelected ? 20 : 30),
        height: logic.isEraserSelected ? 90 : 80,
        width: 55,
        decoration: BoxDecoration(
            color: logic.isEraserSelected ? AppColor.colorGreen : AppColor.green,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
            boxShadow: [BoxShadow(blurRadius: 6, color: AppColor.black.withValues(alpha: 0.5))]),
        child: Image.asset(
          "assets/icons/ic_eraser.webp",
          height: 20,
          width: 20,
        ),
      ),
    );
  });
}

_colorOption() {
  return GetBuilder<PaintController>(
      id: Constant.idColorOption,
      builder: (logic) {
        return InkWell(
          onTap: () => logic.colorOption(),
          child: Container(
            margin: EdgeInsets.only(top: logic.isColorSelected ? 20 : 30),
            height: logic.isColorSelected ? 90 : 80,
            width: 55,
            decoration: BoxDecoration(
                color: logic.isColorSelected ? AppColor.colorGreen : AppColor.green,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                boxShadow: [BoxShadow(blurRadius: 6, color: AppColor.black.withValues(alpha: 0.5))]),
            child: Image.asset(
              "assets/icons/ic_paint_dish.webp",
              height: 20,
              width: 20,
            ),
          ),
        );
      });
}

_colorPickerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GetBuilder<PaintController>(builder: (logic) {
        return Center(
          child: Wrap(
            children: [
              AlertDialog(
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                content: ColorPicker(
                  pickerColor: logic.currentColor!,
                  onColorChanged: (value) {
                    logic.onColorPickerDialogColorChanged(value);
                  },
                  colorPickerWidth: 300,
                  pickerAreaHeightPercent: 0.7,
                  enableAlpha: false,
                  labelTypes: const [],
                  pickerAreaBorderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(2),
                    topRight: Radius.circular(2),
                  ),
                ),
                actionsPadding: EdgeInsets.zero,
                buttonPadding: EdgeInsets.zero,
                actions: [
                  TextButton(
                      child: Text("txtCancel".tr, style: const TextStyle(color: AppColor.themeDark)),
                      onPressed: () => logic.onColorPickerDialogCancel()),
                  TextButton(
                    child: Text(
                      "txtOK".tr,
                      style: const TextStyle(color: AppColor.themeDark),
                    ),
                    onPressed: () => logic.onColorPickerDialogOk(),
                  )
                ],
              ),
            ],
          ),
        );
      });
    },
  );
}

_saveDialog(context) {
  showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<PaintController>(builder: (logic) {
          return Center(
            child: Wrap(
              children: [
                AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    actionsPadding: EdgeInsets.zero,
                    title: Text(
                      "txtAreYouSureYouWantToSave".tr,
                    ),
                    actions: [
                      TextButton(
                        child: Text("txtNo".tr, style: const TextStyle(color: AppColor.themeDark)),
                        onPressed: () {
                          logic.onSaveDialogNo;
                          Get.back();
                        },
                      ),
                      TextButton(
                        child: Text(
                          "txtYes".tr,
                          style: const TextStyle(color: AppColor.themeDark),
                        ),
                        onPressed: () {
                          logic.onSaveDialogYes(context);
                          Get.back();
                        },
                      )
                    ]),
              ],
            ),
          );
        });
      });
}

_restartDialog(context) {
  showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<PaintController>(builder: (logic) {
          return Center(
            child: Wrap(
              children: [
                AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    actionsPadding: EdgeInsets.zero,
                    title: Text(
                      "txtAreYouSureYouWantToReset".tr,
                    ),
                    actions: [
                      TextButton(
                        child: Text("txtNo".tr, style: const TextStyle(color: AppColor.themeDark)),
                        onPressed: () => logic.onRestartDialogNo(),
                      ),
                      TextButton(
                        child: Text(
                          "txtYes".tr,
                          style: const TextStyle(color: AppColor.themeDark),
                        ),
                        onPressed: () {
                          logic.onRestartDialogYes(context);
                          logic.isRestartShow = false;
                        },
                      )
                    ]),
              ],
            ),
          );
        });
      });
}
