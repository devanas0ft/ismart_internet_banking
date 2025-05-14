import 'package:flutter/material.dart';
//import 'package:ismart/app/theme.dart';

import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/utils/url_launcher.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieDetailsScreen extends StatefulWidget {
  final UtilityResponseData moviedetail;

  const MovieDetailsScreen({Key? key, required this.moviedetail})
    : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  // final videoUrl = "https://www.youtube.com/embed/o17MF9vnabg";

  // late YoutubePlayerController _controller;

  // @override
  // void initState() {
  //   final videoId = YoutubePlayerController.convertUrlToId(videoUrl);

  //   _controller = YoutubePlayerController.fromVideoId(
  //     videoId: videoId!,
  //     params: const YoutubePlayerParams(
  //       showControls: true,
  //       showFullscreenButton: false,
  //       strictRelatedVideos: true,
  //     ),
  //   );
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _controller.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    //   final _theme = Theme.of(context);
    //  final _textTheme = _theme.textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4.h, left: 2.w),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  NavigationService.pop();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                widget.moviedetail.findValue(primaryKey: "movieName"),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  Text(
                    widget.moviedetail.findValue(primaryKey: "genre") ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 15,
                    color: CustomTheme.darkGray.withOpacity(0.5),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    widget.moviedetail.findValue(primaryKey: "duration"),
                    style: TextStyle(
                      fontSize: 13,
                      color: CustomTheme.darkGray.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 92.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.moviedetail.findValue(primaryKey: "banner"),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // child: YoutubePlayer(
                    //   controller: _controller,
                    //   aspectRatio: 16 / 9,
                    // ),
                  ),
                  SizedBox(height: 8.hp),
                  CustomRoundedButtom(
                    borderColor: CustomTheme.darkGray.withOpacity(0.5),
                    textColor: CustomTheme.darkGray.withOpacity(0.5),
                    horizontalMargin: 30.w,
                    padding: EdgeInsets.all(1.5.w),
                    title: 'Watch Trailer',
                    color: Colors.transparent,
                    onPressed: () {
                      //  print(" this is the result ::${channelId}");
                      UrlLauncher.launchUrlLink(
                        context: context,
                        url:
                            widget.moviedetail.findValue(
                              primaryKey: "trailerVideo",
                            ) ??
                            '',
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Synopsis",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: .7.h),
                  Text(
                    widget.moviedetail.findValue(primaryKey: "synopsis") ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomTheme.darkGray.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Director",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: .7.h),
                  Text(
                    widget.moviedetail.findValue(primaryKey: "director") ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomTheme.darkGray.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cast",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: .7.h),
                  Text(
                    widget.moviedetail.findValue(primaryKey: "casts") ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomTheme.darkGray.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: CustomRoundedButtom(
                title: 'BUY TICKETS',
                onPressed: () {
                  NavigationService.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
