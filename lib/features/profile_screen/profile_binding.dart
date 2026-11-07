

import '../export.dart';

class ProfileBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ProfileController>(()=> ProfileController(), fenix: true);
  }

}