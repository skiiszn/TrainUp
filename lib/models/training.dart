// models/training_plan_model.dart
import 'package:TrainUp/models/exercise.dart';

class TrainingPlan {
  final String id;
  final String name;
  final List<String> category;
  final String tags;
  final List<Exercise> exercises;
  final String restTime;
  final int totalReps;
  final List<String> requiredEquipmentList;
  final String totalTime;

  TrainingPlan({
    required this.id,
    required this.name,
    required this.category,
    required this.tags,
    required this.exercises,
    required this.restTime,
    required this.totalReps,
    required this.requiredEquipmentList,
    required this.totalTime,
  });

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      id: json['id'],
      name: json['name'],
      category: List<String>.from(json['category']),
      tags: json['tags'],
      exercises: List<Exercise>.from(
          json['exercises'].map((x) => Exercise.fromJson(x))),
      restTime: json['restTime'],
      totalReps: json['totalSets'],
      requiredEquipmentList: List<String>.from(json['requiredEquipmentList']),
      totalTime: json['totalTime'],
    );
  }
}
