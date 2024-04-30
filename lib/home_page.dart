import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:TrainUp/video_info.dart';
import 'models/info.dart';
import 'themes/colors.dart' as color;
import 'dart:math';
import 'package:TrainUp/area_of_focus_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Random random;
  List<Info> info = [];
  late String nextWorkoutId;
  Map<String, dynamic>? trainingPlan;
  List<dynamic>? plans;

  _initData() async {
    var res = await DefaultAssetBundle.of(context).loadString("json/info.json");
    var resInfo = json.decode(res);
    setState(() {
      info = List<Info>.from(resInfo.map((x) => Info.fromJson(x)));
    });
  }

  @override
  void initState() {
    _initData();
    super.initState();
    random = Random();
    int randomNumber = random.nextInt(8) + 1;
    nextWorkoutId = randomNumber.toString();
    _loadWorkoutPlan();
  }

  void _loadWorkoutPlan() async{
    // Load the workout plan corresponding to nextWorkoutId
    // Load JSON data from file
    String jsonData = await DefaultAssetBundle.of(context)
        .loadString("json/trainings.json");

    // Decode JSON data
    Map<String, dynamic> decodedData = json.decode(jsonData);

    // Find the training plan with the specified workout ID
    plans = decodedData['trainingPlans'];
    for (var plan in plans!) {
      if (plan['id'] == nextWorkoutId) {
        trainingPlan = plan;
        break;
      }
    }
  }

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
        child: Column(
          children: [
            //First row text
            Row(
              children: [
                Text(
                  "Training",
                  style: TextStyle(
                      fontSize: 30,
                      color: color.AppColor.homePageTitle,
                      fontWeight: FontWeight.w700),
                ),
                Expanded(child: Container()), //Creating space
                Icon(Icons.arrow_back_ios,
                    size: 20, color: color.AppColor.homePageIcons),
                const SizedBox(
                  width: 10,
                ), //Empty sized box for padding
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: color.AppColor.homePageIcons,
                ),
                const SizedBox(
                  width: 15,
                ), //Empty sized box for padding
                Icon(Icons.arrow_forward_ios,
                    size: 20, color: color.AppColor.homePageIcons),
              ],
            ),
            const SizedBox(
              width: 30,
            ),
            //Second row text and details
            Row(
              children: [
                Text(
                  "Your program",
                  style: TextStyle(
                      fontSize: 20,
                      color: color.AppColor.homePageSubtitle,
                      fontWeight: FontWeight.w700),
                ),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    if (trainingPlan != null) {
                       Get.to(() => VideoInfo(trainingPlan: trainingPlan!));
                    }
                  },
                  child: Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 20,
                      color: color.AppColor.homePageDetail,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    if (trainingPlan != null) {
                       Get.to(() => VideoInfo(trainingPlan: trainingPlan!));
                    }
                  },
                  child: Icon(Icons.arrow_forward,
                      size: 20, color: color.AppColor.homePageIcons),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            //Bog box with radius container and next workout details
            Container(
              width: MediaQuery.of(context).size.width,
              height: 220,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    color.AppColor.gradientFirst.withOpacity(0.8),
                    color.AppColor.gradientSecond.withOpacity(0.9),
                  ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(80)),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(10, 10),
                        blurRadius: 25,
                        color: color.AppColor.gradientSecond.withOpacity(0.2)),
                  ]),
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
                        color: color.AppColor.homePageContainerTextSmall,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      trainingPlan?['name'] ?? "",
                      style: TextStyle(
                        fontSize: 25,
                        color: color.AppColor.homePageContainerTextSmall,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Intensity - ${trainingPlan?['tags'] ?? ""}",
                      style: TextStyle(
                        fontSize: 20,
                        color: color.AppColor.homePageContainerTextSmall,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timer,
                                size: 20,
                                color:
                                    color.AppColor.homePageContainerTextSmall),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              trainingPlan?['totalTime'] ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    color.AppColor.homePageContainerTextSmall,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        InkWell(
                  onTap: () {
                    if (trainingPlan != null) {
                       Get.to(() => VideoInfo(trainingPlan: trainingPlan!));
                    }
                  },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: color.AppColor.gradientFirst,
                                  blurRadius: 12,
                                  offset: const Offset(3, 7),
                                )
                              ]),
                          child: const Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            //Motivational container
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  //Background image
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 30),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/card.jpg"),
                          fit: BoxFit.fill),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          offset: const Offset(8, 10),
                          color: color.AppColor.gradientSecond.withOpacity(0.3),
                        ),
                        BoxShadow(
                          blurRadius: 10,
                          offset: const Offset(-1, -5),
                          color: color.AppColor.gradientSecond.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  //Girl image over the background one
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(right: 200, bottom: 30),
                    decoration: BoxDecoration(
                      //color: Colors.redAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/figure.png"),
                        //fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  //Info / text to the right
                  Container(
                    width: double.maxFinite,
                    height: 100,
                    margin: const EdgeInsets.only(
                      left: 150,
                      top: 50,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You are doing great",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color.AppColor.homePageDetail,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "Keep it up\n",
                                  style: TextStyle(
                                    color: color.AppColor.homePagePlanColor,
                                    fontSize: 16,
                                  ),
                                  children: const [
                                TextSpan(text: "Stick to your plan"),
                              ])),
                        ]),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Area of focus",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: color.AppColor.homePageTitle,
                  ),
                )
              ],
            ),
            Expanded(
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width,
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                      itemCount: info.length.toDouble() ~/ 2,
                      itemBuilder: (_, i) {
                        int a = 2 * i;
                        int b = 2 * i + 1;
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (trainingPlan != null) {
                                Get.to(() => AreaOfFocusPage(areaOfFocus: info.elementAt(a).title!, workouts: _workoutsForAreaOfFocus(info.elementAt(a).title!)));
                                  }
                                },
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 90) / 2,
                              height: 170,
                              margin: const EdgeInsets.only(
                                left: 30,
                                bottom: 15,
                                top: 15,
                              ),
                              padding: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image:
                                      AssetImage(info.elementAt(a).img ?? ""),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: const Offset(5, 5),
                                    color: color.AppColor.gradientSecond
                                        .withOpacity(0.1),
                                  ),
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: const Offset(-5, -5),
                                    color: color.AppColor.gradientSecond
                                        .withOpacity(0.1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      info.elementAt(a).title ?? "",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: color.AppColor.homePageDetail,
                                      ),
                                    )),
                              ),
                            ),
                            ),
                            InkWell(
                            onTap: () {
                              if (trainingPlan != null) {
                                Get.to(() => AreaOfFocusPage(areaOfFocus: info.elementAt(b).title!, workouts: _workoutsForAreaOfFocus(info.elementAt(b).title!)));
                              }
                            },
                            child : Container(
                              width:
                                  (MediaQuery.of(context).size.width - 90) / 2,
                              height: 170,
                              margin: const EdgeInsets.only(
                                left: 30,
                                bottom: 15,
                                top: 15,
                              ),
                              padding: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image:
                                      AssetImage(info.elementAt(b).img ?? ""),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: const Offset(5, 5),
                                    color: color.AppColor.gradientSecond
                                        .withOpacity(0.1),
                                  ),
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: const Offset(-5, -5),
                                    color: color.AppColor.gradientSecond
                                        .withOpacity(0.1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      info.elementAt(b).title ?? "",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: color.AppColor.homePageDetail,
                                      ),
                                    )),
                              ),
                            ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<Map<String, dynamic>> _workoutsForAreaOfFocus(String s) {
    
    List<Map<String, dynamic>> workouts = [];
    String category = s;
    if(s == "Random"){
    // Lista stringova
    List<String> strings = ["Arms", "Glutes", "Legs", "Full Body"];
    Random random = Random();
    int randomIndex = random.nextInt(strings.length);
    category = strings[randomIndex];
    }

    for (var plan in plans!) {
      if (plan['category'].contains(category)) {
        workouts.add(plan);
      }
    }
    return workouts;
  }
}
