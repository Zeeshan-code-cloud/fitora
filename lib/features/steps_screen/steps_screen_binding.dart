import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/features/steps_screen/step_screen_controller.dart';

class StepsScreenBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => StepScreenController(), fenix: true);
  }

}