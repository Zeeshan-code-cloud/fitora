import 'dart:async';

import 'package:fitoraa/features/export.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkController extends GetxController {
  static NetworkController get to => Get.find();
  final RxBool isConnected = false.obs;
  final RxBool slowInternetConnections = false.obs;

  StreamSubscription? internetSub;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    listenInternetStatus();
  }
  void listenInternetStatus() {
    internetSub = InternetConnection().onStatusChange.listen((status) async {
      switch (status) {
        case InternetStatus.connected:
          isConnected.value = true;
          slowInternetConnections.value = false;
          break;
        case InternetStatus.disconnected:
          isConnected.value = false;
          slowInternetConnections.value = false;
          break;
        }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    internetSub!.cancel();
  }
}
