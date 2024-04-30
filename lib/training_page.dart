import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:TrainUp/models/training.dart';
import 'package:TrainUp/services/training_data.dart';
import 'package:TrainUp/widgets/circular_countdown_timer_widget.dart';
import 'themes/colors.dart' as color;

class TrainingPage extends StatefulWidget {
  final String trainingId;

  const TrainingPage({Key? key, required this.trainingId}) : super(key: key);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  TrainingPlan? _trainingPlan;
  int _currentExerciseIndex = -1; // Index of the current exercise
  bool _isResting = false; // Flag to track if it's resting time
  bool _isPreparing = true; // Flag to track if it's preparation time

  @override
  void initState() {
    super.initState();
    _fetchTrainingData();
  }

  Future<void> _fetchTrainingData() async {
    try {
      String str = widget.trainingId;
      print(str);
      final TrainingPlan? trainingPlan =
          await TrainingDataService.getTrainingPlanById(str);
      setState(() {
        _trainingPlan = trainingPlan;
        print('Training plan set: $_trainingPlan');
      });
    } catch (e) {
      // Handle error if unable to fetch training data
      //print('Error fetching training data: $e');
    }
  }

  void _nextStep() {
    setState(() {
      if (_isPreparing) {
        _isPreparing = false;
        _currentExerciseIndex++;
      } else {
        _isResting = !_isResting;
        if (!_isResting) {
          _currentExerciseIndex++;
        }
      }
    });
  }

  int _getDuration() {
    print(_currentExerciseIndex);
    if (_currentExerciseIndex == -1) {
      print('10s one');
      // Preparation time
      return 10;
    } else {
      //print('duration that is passed:');
      // Exercise time
      //print(_trainingPlan!.exercises[_currentExerciseIndex].duration);
      if (!_isResting) {
        if (_currentExerciseIndex < _trainingPlan!.exercises.length) {
          return _parseDuration(
              _trainingPlan!.exercises[_currentExerciseIndex].duration);
        } else {
          return 0; // Completed all exercises
        }
      } else {
        return _parseDuration(_trainingPlan!.restTime);
      }
    }
  }

  void _startTimer(int duration) {
    // Start the timer with the specified duration
    // Code for starting timer goes here...
  }

  int _parseDuration(String duration) {
    final parts = duration.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);
    return hours * 3600 + minutes * 60 + seconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color.AppColor.homePageBackground,
        title: Text(
          _trainingPlan != null ? _trainingPlan!.name : 'Training Page',
          style: TextStyle(
              color: color.AppColor.secondPageTitleColor,
              fontWeight: FontWeight.w400),
        ),
      ),
      backgroundColor: color.AppColor.homePageBackground,
      body: Container(
        child: _trainingPlan != null
            ? Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Adjust spacing
                      Container(
                        width: 250,
                        height: 250,
                        child: CircularCountdownTimerWidget(
                          duration: _getDuration(),
                          textStyle: TextStyle(
                              color:
                                  color.AppColor.gradientFirst.withOpacity(0.8),
                              fontSize: 36,
                              fontWeight: FontWeight.w800),
                          onTimerComplete: () {
                            _nextStep();
                          },
                          updateDuration: () =>
                              _getDuration(), // Pass a function to update the duration
                        ),
                      ),
                      SizedBox(height: 35),
                      Text(
                        _isPreparing
                            ? 'Prepare'.toUpperCase()
                            : _isResting
                                ? 'Rest'.toUpperCase()
                                : (_currentExerciseIndex <
                                        _trainingPlan!.exercises.length)
                                    ? '${_trainingPlan!.exercises[_currentExerciseIndex].name}'
                                    : 'COMPLETED',
                        style: TextStyle(
                            color:
                                color.AppColor.gradientFirst.withOpacity(0.8),
                            fontSize: 24,
                            fontWeight: FontWeight.w800),
                      ),
                      // Add more widgets to display other training plan data
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
