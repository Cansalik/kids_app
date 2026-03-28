import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/database/tables/vide_table.dart';
import 'package:kids_playroom/routes/app_routes.dart';
import 'package:kids_playroom/ui/videoList/controller/video_list_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/preference.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/google_ads/custom_ad.dart';
import 'package:kids_playroom/utils/utils.dart';
import 'package:photo_view/photo_view.dart';

class VideoListScreen extends StatelessWidget {
  final VideoListController videoListController = Get.find<VideoListController>();

  VideoListScreen({super.key});

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
        title: Text(
          videoListController.title!.split("#")[0].tr,
          style: TextStyle(color: AppColor.colorGreen, fontSize: AppFontSize.size_16, fontWeight: FontWeight.bold, fontFamily: "UrbanistBlack"),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: GetBuilder<VideoListController>(builder: (logic) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: logic.videoList?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: (8 / 11), crossAxisSpacing: AppFontSize.size_12, mainAxisSpacing: AppFontSize.size_8),
                  itemBuilder: (BuildContext context, int index) {
                    return subcategory(logic.videoList![index], index);
                  },
                ),
              ),
              const BannerAdClass()
            ],
          );
        }),
      ),
    );
  }

  subcategory(VideoTable videoList, int index) {
    var str = videoList.videoDescription;
    var parts = str?.split('#');
    var id = parts?[0].trim() ?? "";
    var title = parts?.sublist(1).join(':').trim() ?? "";
    var videoThumb = "https://i3.ytimg.com/vi/$id/hqdefault.jpg";
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.videoPlayer, arguments: [index])?.then((value) {
          Preference.shared.getBool(Preference.isMusic) ?? true ? Utils.audioPlayer.resume() : Utils.audioPlayer.stop();
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
              statusBarColor: AppColor.colorTheme));
          Get.forceAppUpdate();
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: AppColor.colorGray50, spreadRadius: 1, offset: Offset(1.2, 0.5), blurRadius: 5)]),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: AppSizes.height_15,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PhotoView(
                    gaplessPlayback: true,
                    minScale: PhotoViewComputedScale.covered * 1.35,
                    maxScale: PhotoViewComputedScale.covered * 1.35,
                    imageProvider: NetworkImage(videoThumb),
                  ),
                ),
              ),
              SizedBox(
                height: AppFontSize.size_8,
              ),
              Expanded(
                child: AutoSizeText(
                  title,
                  textAlign: TextAlign.center, // Center the text horizontally
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
