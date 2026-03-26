
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/custom/convert/number_to_word.dart';
import 'package:kids_playroom/ui/numbers/controllers/numbers_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';

class NumbersScreen extends StatelessWidget {
  NumbersScreen({super.key});

  final NumbersController numbersController = Get.find<NumbersController>();

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
            child: Image.asset(Constant.getAssetIcons() + "btn_back_150.png",
                width: AppSizes.height_4_5),
          ),
        ),
        title: Text(
            numbersController.title
                .toString()
                .tr,
          style: TextStyle(
              color: AppColor.colorGreen,
              fontSize: AppFontSize.size_16,
              fontWeight: FontWeight.bold,
              fontFamily: "UrbanistBlack"),
        ),
      ),
      backgroundColor: AppColor.bg,
      body: GetBuilder<NumbersController>(id: Constant.idNumbers,builder: (logic) {
        return SafeArea(
          top: false,
          bottom:true ,
          child: _numScreenWidget(),
        );
      }),
    );
  }

  topBar() {
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
              child: Image.asset(Constant.getAssetIcons() + "btn_back_150.png",
                  height: AppSizes.height_5),
            ),
            Center(
              child: Text(numbersController.title
                  .toString()
                  .tr,
                style: TextStyle(
                    color: AppColor.colorGreen,
                    fontSize: AppFontSize.size_16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

}


_numScreenWidget() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
    width: double.infinity,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/background/bg_background.webp"),
          fit: BoxFit.fill),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _numberBoy(),
        _numText(),
        _numbers(),
      ],
    ),
  );
}

_numText() {
  return GetBuilder<NumbersController>(builder: (logic) {
    return Text(
      NumberToWord().convert(logic.current!).toUpperCase(),
      style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColor.colorBlueGreen),
    );
  });
}

_numbers() {
  return GetBuilder<NumbersController>(
      id: Constant.idNumbers,
      builder: (logic) {
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
                horizontal: AppFontSize.size_2, vertical: AppFontSize.size_2),
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () => logic.onTtsClick(index),
                child: Image.asset(
                  Constant.getAssetDragNumbers() + "${index + 1}.webp",
                ),
              );
            });
      });
}

_numberBoy() {
  return GetBuilder<NumbersController>(builder: (logic) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          Constant.getAssetDragImages() + "number_boy.webp",
          height: AppSizes.height_28,
        ),
        Container(
          margin: EdgeInsets.only(top: AppSizes.height_9),
          child: Text(
            logic.current!.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 58,
                fontFamily: "Bubble Bobble",
                color: AppColor.colorBlueLight),
          ),
        ),
      ],
    );
  });
}
