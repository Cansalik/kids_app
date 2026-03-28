
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/ui/video_player/controller/video_player_controller.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {

        // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        //     statusBarColor: AppColor.white));
    return GetBuilder<VideoPlayerController>(builder: (logic) {
      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop,result){
          print("::::::::::::${logic.isFullScreen}");
          if(didPop){
            if(logic.isFullScreen) {
              logic.controller.exitFullScreen();
            }
            /*SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown
          ]);*/
          }
        },
        child: YoutubePlayerScaffold(
          backgroundColor:AppColor.white ,
          controller: logic.controller,
          /*onExitFullScreen: () {
            SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                statusBarColor: AppColor.transparent));
          },*/
         /* player: YoutubePlayer(
            controller: logic.controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            topActions: <Widget>[
              IconButton(
                  onPressed: () {
                    Get.back();
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown
                    ]);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColor.white,
                  )),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  logic.videoTitle[logic.index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
            onReady: () {
              logic.isPlayerReady = true;
            },
            onEnded: (data) {
              logic.controller.load(logic.videoIds[
                  (logic.videoIds.indexOf(data.videoId) + 1) %
                      logic.videoIds.length]);
              logic.showSnackBar('Next Video Started!', context);
            },

          ),*/

          builder: (context, player) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  player,
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      logic.videoTitle[logic.index],
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: AppFontSize.size_14),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: logic.videoTitle.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            logic.changeVideo(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10.0,
                              right: 10,
                              left: 10,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: AppColor.colorGray50,
                                        spreadRadius: 1,
                                        offset: Offset(1.2, 0.5),
                                        blurRadius: 5)
                                  ]),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: AppSizes.height_10,
                                    width: AppSizes.height_15,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: PhotoView(
                                        gaplessPlayback: true,
                                        minScale:
                                            PhotoViewComputedScale.covered * 1.35,
                                        maxScale:
                                            PhotoViewComputedScale.covered * 1.35,
                                        imageProvider:
                                            NetworkImage(logic.videoThumb[index]),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AutoSizeText(
                                      logic.videoTitle[index],
                                      textAlign: TextAlign.left,
                                      // Center the text horizontally
                                      style: TextStyle(
                                          fontSize: AppFontSize.size_12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

    /*      return YoutubePlayerScaffold(
        controller: logic.controller,
        builder: (context, player) {
          return Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    player,
                    const VideoPositionIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        logic.videoTitle[logic.index],
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: AppFontSize.size_14),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: logic.videoTitle.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                             logic.changeVideo(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10.0,
                                right: 10,
                                left: 10,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: AppColor.colorGray50,
                                          spreadRadius: 1,
                                          offset: Offset(1.2, 0.5),
                                          blurRadius: 5)
                                    ]),
                                child: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: AppSizes.height_10,
                                      width: AppSizes.height_15,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: PhotoView(
                                          gaplessPlayback: true,
                                          minScale:
                                              PhotoViewComputedScale.covered *
                                                  1.35,
                                          maxScale:
                                              PhotoViewComputedScale.covered *
                                                  1.35,
                                          imageProvider: NetworkImage(
                                              logic.videoThumb[index]),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(
                                        logic.videoTitle[index] ?? "",
                                        textAlign: TextAlign.left,
                                        // Center the text horizontally
                                        style: TextStyle(
                                            fontSize: AppFontSize.size_14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          );
        },
      );*/
    });
  }
}
