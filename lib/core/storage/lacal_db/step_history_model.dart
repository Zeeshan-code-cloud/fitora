import 'package:hive/hive.dart';
part 'step_history_model.g.dart';


@HiveType(typeId: 1)
class StepHistoryModel extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  int steps;

  @HiveField(2)
  double calories;

  @HiveField(3)
  double distance;

  @HiveField(4)
  int activeMinutes;

  StepHistoryModel({
    required this.date,
    required this.steps,
    required this.calories,
    required this.distance,
    required this.activeMinutes,
  });
}