// training_data_service.dart
import 'dart:convert'; // For JSON parsing
import 'package:flutter/services.dart'; // For loading JSON file
import 'package:TrainUp/models/training.dart';

class TrainingDataService {
  static Future<List<TrainingPlan>> getTrainingPlans() async {
    final String jsonString =
        await rootBundle.loadString('json/trainings.json');
    final List<dynamic> jsonData = json.decode(jsonString)['trainingPlans'];
    return jsonData.map((data) => TrainingPlan.fromJson(data)).toList();
  }

  static Future<TrainingPlan?> getTrainingPlanById(String id) async {
    try {
      final List<TrainingPlan> plans = await getTrainingPlans();
      return plans.firstWhere((plan) => plan.id == id);
    } catch (e) {
      return null;
    }
  }
}
