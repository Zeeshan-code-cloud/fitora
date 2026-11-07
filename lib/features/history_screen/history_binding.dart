import 'package:get/get.dart';

import 'history_controller.dart';

class HistoryBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HistoryController(),fenix: true);
  }

}