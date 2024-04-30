// models/exercise_model.dart
class Exercise {
  final String name;
  final String thumbnailUrl;
  final String videoId;
  final String duration;
  final List<String> requiredEquipment;

  Exercise({
    required this.name,
    required this.thumbnailUrl,
    required this.videoId,
    required this.duration,
    required this.requiredEquipment,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['title'],
      thumbnailUrl: json['thumbnail'],
      videoId: json['videoId'],
      duration: json['time'],
      requiredEquipment: List<String>.from(json['requiredEquipment']),
    );
  }
}
