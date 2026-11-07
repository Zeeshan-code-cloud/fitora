 import 'package:get/get.dart';

import 'onboarding_controller.dart';

class OnboadingBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => OnboardingController());
  }

}
