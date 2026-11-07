import 'package:fitoraa/core/storage/lacal_db/step_history_model.dart';
import 'package:hive/hive.dart';

class StepHistoryService {
  static Box<StepHistoryModel> get userHistory =>
      Hive.box<StepHistoryModel>(
        'step_history',
      );
}