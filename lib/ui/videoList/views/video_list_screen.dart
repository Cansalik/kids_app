import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/database/tables/vide_table.dart';
import 'package:kids_playroom/ui/videoList/controller/video_list_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/preference.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:kids_playroom/google_ads/custom_ad.dart';
import 'package:kids_playroom/utils/utils.dart';

class VideoListScreen extends StatelessWidget {
  final VideoListController videoListController =
      Get.find<VideoListController>();

  VideoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColor.colorTheme, // Arka plan rengini belirginleştirdik
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.colorTheme,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "${Constant.getAssetIcons()}btn_back_150.png",
              width: AppSizes.height_4_5,
            ),
          ),
        ),
        title: Text(
          videoListController.title?.split("#")[0].tr ?? "",
          style: TextStyle(
              color: AppColor.colorGreen,
              fontSize: AppFontSize.size_16,
              fontWeight: FontWeight.bold,
              fontFamily: "UrbanistBlack"),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: GetBuilder<VideoListController>(builder: (logic) {
          if (logic.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (logic.videoList == null || logic.videoList!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.ondemand_video_outlined,
                      size: 72,
                      color: AppColor.colorGreen.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bu kategoride henüz video yok',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColor.colorGreen,
                        fontSize: AppFontSize.size_16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "UrbanistBlack",
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Veritabanına video ekledikten sonra burada görünecek.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: AppFontSize.size_12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: logic.videoList?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75, // Daha dengeli bir görünüm
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildVideoItem(logic.videoList![index], index);
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

  Widget _buildVideoItem(VideoTable video, int index) {
    final videoUrl = video.videoUrl ?? "";
    final videoTitle = video.videoName ?? "";
    final youtubeVideoId = _extractYoutubeVideoId(videoUrl);
    final videoThumb = youtubeVideoId == null
        ? null
        : "https://img.youtube.com/vi/$youtubeVideoId/mqdefault.jpg";

    return InkWell(
      onTap: () async {
        if (videoUrl.isEmpty) {
          return;
        }

        final isMusicOn = Preference.shared.getBool(Preference.isMusic) ?? true;
        isMusicOn ? Utils.audioPlayer.pause() : Utils.audioPlayer.stop();

        await Utils.urlLauncher(videoUrl);

        isMusicOn ? Utils.audioPlayer.resume() : Utils.audioPlayer.stop();
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: AppColor.colorTheme));
        Get.forceAppUpdate();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thumbnail Bölümü
              Expanded(
                flex: 7,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: videoThumb == null
                      ? Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.grey,
                              size: 52,
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: videoThumb,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.play_circle_fill,
                                color: Colors.grey, size: 40),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              // Başlık Bölümü
              Expanded(
                flex: 3,
                child: Center(
                  child: AutoSizeText(
                    videoTitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _extractYoutubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }

    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    if (uri.host.contains('youtube.com')) {
      final videoId = uri.queryParameters['v'];
      if (videoId != null && videoId.isNotEmpty) {
        return videoId;
      }
    }

    return null;
  }
}
