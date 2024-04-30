import 'dart:convert';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:TrainUp/models/training.dart';
import 'package:TrainUp/training_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'models/video.dart';
import "themes/colors.dart" as color;

class VideoInfo extends StatefulWidget {
  final Map<String, dynamic> trainingPlan;

  const VideoInfo({Key? key, required this.trainingPlan}) : super(key: key);

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  List<Video> videoInfo = [];
  bool _playArea = false;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller =
        YoutubePlayerController(initialVideoId: ''); // Initialize controller
    _initData();
    super.initState();
  }

  _initData() async {
      // Extract exercises from the training plan
    List<dynamic> exerciseData = widget.trainingPlan['exercises'];
    List<Video> extractedVideos =
        exerciseData.map((data) => Video.fromJson(data)).toList();

    setState(() {
      videoInfo = extractedVideos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            // _playArea == false ?
            BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.AppColor.gradientFirst.withOpacity(0.9),
              color.AppColor.gradientSecond.withOpacity(0.9),
            ],
            begin: const FractionalOffset(0.0, 0.4),
            end: Alignment.topRight,
          ),
        ),
        // : BoxDecoration(
        //     color: color.AppColor.gradientSecond,
        //   ),
        child: Column(
          children: [
            //Checking if video is clicked. If it is.
            //Than we are redrawing container with the video player and playing the video.
            // _playArea == false
            //     ?
            Container(
              padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: color.AppColor.secondPageIconColor,
                        ),
                      ),
                      Expanded(child: Container()),
                      InkWell(
                        onTap: () {
                          _showDetailsDialog(
                              context); // Call the function to show the details dialog
                        },
                        child: Icon(
                          Icons.info_outline,
                          size: 20,
                          color: color.AppColor.secondPageIconColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Center(
                      // Center the button horizontally and vertically
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(TrainingPage(trainingId: widget.trainingPlan["id"]));// Navigate to TrainingPage using GetX
                        },
                        // Button text
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(color
                              .AppColor
                              .gradientFirst), // Button background color
                          foregroundColor: MaterialStateProperty.all(
                              Colors.white), // Button text color
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16)), // Button padding
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30), // Button border radius
                            ),
                          ),
                          elevation: MaterialStateProperty.all(
                              5), // Elevation for shadow effect
                          shadowColor: MaterialStateProperty.all(
                              Colors.black.withOpacity(0.3)), // Shadow color
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'START TRAINING',
                              style: TextStyle(fontSize: 20),
                            ), // Button text
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
            // : Container(
            //     //Container for player area. We will have back button | video player | controls for video
            //     child: Column(
            //       children: [
            //         //Back / info button
            //         Container(
            //           height: 100,
            //           padding: const EdgeInsets.only(
            //               top: 40, left: 30, right: 30),
            //           child: Row(
            //             children: [
            //               InkWell(
            //                 onTap: () {
            //                   Get.back();
            //                 },
            //                 child: Icon(
            //                   Icons.arrow_back_ios,
            //                   size: 20,
            //                   color: color.AppColor.secondPageTopIconColor,
            //                 ),
            //               ),
            //               Expanded(child: Container()),
            //               Icon(
            //                 Icons.info_outline,
            //                 size: 20,
            //                 color: color.AppColor.secondPageTopIconColor,
            //               ),
            //             ],
            //           ),
            //         ),
            //         _playView(context),
            //       ],
            //     ),
            //   ),
            ,
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          widget.trainingPlan['name'] ?? "",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color.AppColor.circuitsColor,
                          ),
                        ),
                        Expanded(child: Container()),
                        Row(
                          children: [
                            Icon(Icons.loop,
                                size: 30, color: color.AppColor.loopColor),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.trainingPlan['totalSets']} sets",
                              style: TextStyle(
                                fontSize: 15,
                                color: color.AppColor.setsColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: _listView(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Video player
  Widget _playView(BuildContext context) {
    if (_controller != null) {
      // Simplify logic
      return Container(
        // height: 300,
        // width: 300,
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      );
    } else {
      return Container(
        height: 300,
        width: 300,
        child: Center(
          child: CircularProgressIndicator(
            color: color.AppColor.secondPageContainerGradient1stColor,
          ),
        ),
      );
    }
  }

  // Getting the specific video and starting to play it || DEPRICATED ||
  _onTapVideo(int index) {
    // Getting currently clicked YouTube video id
    String currentVideoId = videoInfo[index].videoId ?? "";

    // Update controller with new video
    _controller.load(currentVideoId);

    // Update UI state
    setState(() {
      _playArea = true;
    });
  }

  // Show video popup
void _showVideoPopup(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent background
          elevation: 0, // No shadow
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.AppColor.gradientFirst,
                  color.AppColor.gradientSecond,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0), // Rounded corners
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Preview of Exercise'.toUpperCase(),
                    textAlign: TextAlign
                        .center, // Align title in the middle // Title in all caps
                    style: TextStyle(
                      color: color.AppColor.secondPageIconColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing:
                          1.2, // Increased letter spacing for emphasis
                      // All caps
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  child: YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId: videoInfo[index].videoId ?? "",
                      flags: const YoutubePlayerFlags(
                        autoPlay: true,
                        mute: false,
                      ),
                    ),
                    showVideoProgressIndicator: true,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: color.AppColor.secondPageIconColor,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Show details of the workout in popup
  // Show workout details popup
  // Show workout details dialog
  void _showDetailsDialog(BuildContext context) {
    
    List<dynamic> requiredEquipmentList = widget.trainingPlan['requiredEquipmentList'];
    List<String> requiredEquipmentStrings = requiredEquipmentList.map((e) => e.toString()).toList();
    String requiredEquipmentString = requiredEquipmentStrings.join(', ');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Set background color to transparent
          insetPadding:
              EdgeInsets.symmetric(horizontal: 20), // Set horizontal padding
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Add border radius
              gradient: LinearGradient(
                colors: [
                  color.AppColor.gradientFirst.withOpacity(0.9),
                  color.AppColor.gradientSecond.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Info", // Title
                  style: TextStyle(
                    color:
                        color.AppColor.secondPageIconColor, // Title text color
                    fontSize: 18.0, // Title text size
                    fontWeight: FontWeight.bold, // Title text weight
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            color.AppColor.secondPageContainerGradient1stColor
                                .withOpacity(0.6),
                            color.AppColor.secondPageContainerGradient2ndColor
                                .withOpacity(0.6),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: color.AppColor.secondPageIconColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.trainingPlan['totalTime'] ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              color: color.AppColor.secondPageIconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            color.AppColor.secondPageContainerGradient1stColor
                                .withOpacity(0.6),
                            color.AppColor.secondPageContainerGradient2ndColor
                                .withOpacity(0.6),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.handyman_outlined,
                            size: 20,
                            color: color.AppColor.secondPageIconColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            requiredEquipmentString,
                            style: TextStyle(
                              fontSize: 16,
                              color: color.AppColor.secondPageIconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: color.AppColor
                              .secondPageIconColor, // Close button text color
                          fontSize: 16.0, // Close button text size
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Displaying timer for our exercises
  Widget _buildExerciseTracker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 140, // Adjust width as needed
              height: 140, // Adjust height as needed
              child: CircularCountDownTimer(
                width: 140,
                height: 140,
                duration: 300, // Example: 5 minutes (in seconds)
                initialDuration: 0,
                controller: CountDownController(),
                ringColor: Colors.grey[300]!,
                fillColor: Colors.blue,
                strokeWidth: 10.0,
                strokeCap: StrokeCap.round,
                textStyle: TextStyle(
                    fontSize: 33.0,
                    color: color.AppColor.secondPageIconColor,
                    fontWeight: FontWeight.bold),
                textFormat: CountdownTextFormat.S,
                isReverse: true,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: false,
                onComplete: () {
                  // Handle timer completion
                },
              ),
            ),
          ),
        ),
        // Widget for displaying current exercise and repetitions/time left (to be implemented)
        // Control buttons for pause, play, skip (to be implemented)
      ],
    );
  }

  //Registring if we clicked to play a video, changing state...
  _listView() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        itemCount: videoInfo.length,
        itemBuilder: (_, int index) {
          return GestureDetector(
            onTap: () {
              _showVideoPopup(context, index);
              //_onTapVideo(index);
              //debugPrint(index.toString());
              setState(() {
                if (_playArea == false) {
                  _playArea = true;
                }
              });
            },
            child: _buildCard(index),
          );
        });
  }

//Video cards with images and video details
  _buildCard(int index) {
    return Container(
      height: 135,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(
                      videoInfo[index].thumbnail ?? "",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoInfo[index].title ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      videoInfo[index].time ?? "",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Container(
                width: 80,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFeaeefc),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "15s rest",
                    style: TextStyle(
                      color: Color(0xFF839fed),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (int i = 0; i < 70; i++)
                    i.isEven
                        ? Container(
                            width: 3,
                            height: 1,
                            decoration: BoxDecoration(
                              color: const Color(0xFF839fed),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                        : Container(
                            width: 3,
                            height: 1,
                            color: Colors.white,
                          ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

