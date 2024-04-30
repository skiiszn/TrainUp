import 'package:flutter/material.dart';
import 'themes/colors.dart' as color;
import 'package:TrainUp/video_info.dart';
import 'package:get/get.dart';

class AreaOfFocusPage extends StatelessWidget {
  final String areaOfFocus;
  final List<Map<String, dynamic>> workouts;

  const AreaOfFocusPage({Key? key, required this.areaOfFocus, required this.workouts}) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: color.AppColor.homePageBackground,
    body: Container(
      padding: const EdgeInsets.only(
        top: 70,
        left: 30,
        right: 30,
      ),
      decoration: BoxDecoration(
       
      ),
      child: Column(
        children: [
          //First row text
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: color.AppColor.homePageIcons,
                ),
              ),
              Expanded(child: Container()), //Creating space
              Text(
  areaOfFocus.toUpperCase(),
  style: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    shadows: <Shadow>[
      Shadow(
        blurRadius: 15,
        color: Colors.white.withOpacity(0.8), // White shadow with opacity
        offset: const Offset(0, 0),
      ),
      Shadow(
        blurRadius: 10,
        color: color.AppColor.homePageTitle.withOpacity(0.5), // Original text color with opacity
        offset: const Offset(0, 0),
      ),
      Shadow(
        blurRadius: 20,
        color: color.AppColor.homePageTitle.withOpacity(0.5), // Original text color with opacity
        offset: const Offset(0, 0),
      ),
    ],
  ),
),

              Expanded(child: Container()), //Creating space
            ],
          ),
          const SizedBox(
            width: 30,
          ),
// Big box with radius container and next workout details
Expanded(
  child: ListView.builder(
    itemCount: workouts.length,
    itemBuilder: (_, index) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width,
        height: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8), // Black gradient
              Colors.black.withOpacity(0.9), // Black gradient
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
            bottomLeft: const Radius.circular(10),
            topRight: const Radius.circular(80),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: const Offset(8, 10),
              color: Colors.white.withOpacity(0.8), // Box shadow color
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            top: 25,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Next workout",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // White text
                ),
              ),
              const SizedBox(height: 5),
              Text(
                workouts[index]?['name'] ?? "",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white, // White text
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Intensity - ${workouts[index]['tags'] ?? ""}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white, // White text
                ),
              ),
              const SizedBox(height: 4),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        
                        Icons.timer,
                        size: 20,
                        color: Colors.white, // White text
                      ),
                      const SizedBox(width: 10),
                      Text(
                        workouts[index]?['totalTime'] ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white, // White text
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      if (workouts != null) {
                        Get.to(() => VideoInfo(trainingPlan: workouts[index]));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange,
                                  blurRadius: 10,
                                  offset: const Offset(3, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_circle_fill,
                        color: Colors.white, // White icon
                        size: 60,
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
  ),
),

          const SizedBox(height: 5),
        ],
      ),
    ),
  );
}
}