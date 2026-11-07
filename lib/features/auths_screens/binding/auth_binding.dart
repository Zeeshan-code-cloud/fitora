import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitoraa/features/auths_screens/domain/repository/user_repo.dart';
import 'package:fitoraa/features/auths_screens/domain/use_cases/auth_use_case.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import '../data/user_repo_imple.dart';
import '../presentations/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    //Due to dependency injections don't create an object in a class give it from out side
    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance, fenix: true);
    Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance, fenix: true);

    //when user call userRepo then provide object of UserRepoImple
    Get.lazyPut<UserRepo>(
      () => UserRepoImple(
         auth: Get.find<FirebaseAuth>(),
        firestore: Get.find<FirebaseFirestore>(),
      ),
      fenix: true,
    );

    //now registered the use case
    Get.lazyPut(() => RegisteredUseCase(userRepo: Get.find<UserRepo>()), fenix: true);
    Get.lazyPut(() => LogOutUseCase(userRepo: Get.find<UserRepo>()), fenix: true);
    Get.lazyPut(() => LoginUseCase(userRepo: Get.find<UserRepo>()), fenix: true);
    Get.lazyPut(() => ForgetPasswordUseCase(userRepo: Get.find<UserRepo>()), fenix: true);
    Get.lazyPut(() => UpdateUserProfileUseCase(userRepo: Get.find<UserRepo>()), fenix: true);
    Get.lazyPut(() => GetCurrentUserSession(userRepo: Get.find<UserRepo>()), fenix: true);
    Get.lazyPut(() => VerifiedEmail(userRepo: Get.find<UserRepo>()), fenix: true);
     Get.lazyPut(() => ResendVerificationEmail(userRepo: Get.find<UserRepo>()), fenix: true);
     Get.lazyPut(() => DeleteAccount(userRepo: Get.find<UserRepo>()), fenix: true);

    // Only register AuthController if not already registered
    if (!Get.isRegistered<AuthController>()) {
      Get.put(
        AuthController(
          registeredUseCase: Get.find<RegisteredUseCase>(),
          loginUseCase: Get.find<LoginUseCase>(),
          forgetPasswordUseCase: Get.find<ForgetPasswordUseCase>(),
          logOutUseCase: Get.find<LogOutUseCase>(),
          getCurrentUserSession: Get.find<GetCurrentUserSession>(),
          updateUserProfileUseCase: Get.find<UpdateUserProfileUseCase>(),
          verifiedEmail: Get.find<VerifiedEmail>(),
           resendVerificationEmail: Get.find<ResendVerificationEmail>(),
          deleteAccount: Get.find<DeleteAccount>()
        ),
        permanent: true,
      );
    }
  }
}
