import 'dart:async';
import 'package:fitoraa/features/auths_screens/data/user_model.dart';
import 'package:fitoraa/features/auths_screens/domain/use_cases/auth_use_case.dart';
import 'package:fitoraa/widgets/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../export.dart';

class AuthController extends GetxController {
  RegisteredUseCase registeredUseCase;
  LoginUseCase loginUseCase;
  ForgetPasswordUseCase forgetPasswordUseCase;
  LogOutUseCase logOutUseCase;
  UpdateUserProfileUseCase updateUserProfileUseCase;
  GetCurrentUserSession getCurrentUserSession;
   VerifiedEmail verifiedEmail;
  ResendVerificationEmail resendVerificationEmail;
  DeleteAccount deleteAccount;
  AuthController({
    required this.registeredUseCase,
    required this.loginUseCase,
    required this.forgetPasswordUseCase,
    required this.logOutUseCase,
    required this.updateUserProfileUseCase,
    required this.getCurrentUserSession,
    required this.verifiedEmail,
     required this.resendVerificationEmail,
    required this.deleteAccount,
  });

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxBool isPasswordVisible = true.obs;
  RxBool isTerAccepted = false.obs;
  Rxn<UserModel> currentUser = Rxn<UserModel>();
  RxBool isLoading = false.obs;
  RxBool isLogging = false.obs;
  RxBool isLoggingOut = false.obs;
  RxBool isRegistering = false.obs;
  RxBool isUpdating = false.obs;
  RxBool isSendingEmail = false.obs;
  RxBool isVerifyingEmail = false.obs;
  RxBool isDeletingAccount = false.obs;
  RxInt resendSeconds = 60.obs;
  RxBool canResend = true.obs;




  void moveToForgetPasswordScreen() {
    emailController.clear();
    Get.toNamed(AppRoutes.forgetPasswordScreen);
  }

  void toggledPassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void moveToSignUpScreen(){
    emailController.clear();
    passwordController.clear();
    Get.toNamed(AppRoutes.signUpScreen);

  }
  void moveToLoginScreen(){
    emailController.clear();
    passwordController.clear();

    fullNameController.clear();
    passwordController.clear();
    Get.toNamed(AppRoutes.signInScreen);

  }

  Future registerUser() async {
     if(!formKey.currentState!.validate()){
    return;
    }
     else if(isTerAccepted.value == false ){
      AppSnackbar.show(title: "Terms Required", message: "Please accept the Terms & Conditions to continue.");
      return;
    }
     else if(passwordController.text.trim() != confirmPasswordController.text.trim()){
       AppSnackbar.show(title: "passwords not matching", message: "password and confirm password are not matching");
       return;
     }

    else{
      isRegistering.value = true;
      final user = UserModel(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        createdAt: DateTime.now(),
      );
      final result = await registeredUseCase.call(user);
      result.fold(
            (failure) {
          isRegistering.value = false;
          Get.snackbar("error", failure.errorMessage.toString());
        },
            (success) {
          isRegistering.value = false;
          currentUser.value = success;
          Get.toNamed(AppRoutes.otpScreen, arguments: {
            "email": emailController.text.trim(),
          });
        },
      );
    }
  }

  Future verifyEmail() async {
   final result =  await verifiedEmail.call(currentUser.value!.email);
   isVerifyingEmail.value = true;
   result.fold(
           (error){
             isVerifyingEmail.value = false;
             AppSnackbar.show(title: "not verified",
                 message: "the email address are not verified");
           },
           (success){
             isVerifyingEmail.value = false;
             Get.offAllNamed(AppRoutes.bottomNavScreen);
   });
  }


  Future resendVerificationLink() async {
    print("workig");
    print("workig");
    isSendingEmail.value = true;

    final res =  await resendVerificationEmail.call(currentUser.value!.email);
   res.fold((error){
     isSendingEmail.value = false;
     AppSnackbar.show(title: "link not send", message: "the verification are not send to the email");
   }, (success){
     isSendingEmail.value = false;
    });
  }

  void startResendTimer() {
    // canResend.value = true;
    resendSeconds.value = 60;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future loginUser() async {
    isLogging.value =  true;
    final user = UserModel(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      createdAt: DateTime.now(),
      fullName: fullNameController.text.trim(),
    );
    final result = await loginUseCase.call(user);
    result.fold((failure){
      isLogging.value = false;
      Get.snackbar("error", failure.errorMessage.toString());
    }, (success){
      isLogging.value = false;
      currentUser.value = success;
      Get.toNamed(AppRoutes.bottomNavScreen);
      });

  }
  Future forgetPassword() async {
    final result = await forgetPasswordUseCase.call(emailController.text.trim());
    result.fold(
      (failure) {
        Get.snackbar("error", failure.errorMessage.toString());
      },
      (success) {
        Get.snackbar("Success", "password reset link send to the \n${emailController
            .text.trim()}");
      });
  }
  Future updateProfile(String name) async {
       isUpdating.value = true;
    final result = await updateUserProfileUseCase.call(name.trim());
    result.fold(
      (failure) {
        isUpdating.value = false;
        Get.snackbar("error", failure.errorMessage.toString());
      },
      (success) {
        isUpdating.value = false;
        currentUser.value = currentUser.value!.copyWith(fullName: name);

        Get.snackbar("Success", "profile updated");
      },
    );
  }
  Future logOut() async {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    final result = await logOutUseCase.call();
    result.fold(
      (failure) {
        Get.snackbar("error", failure.errorMessage.toString());
      },
      (success) {
        Get.offAllNamed(AppRoutes.signInScreen);
      },
    );
  }
  Future getCurrentUserSessionMethod() async {
    final userModel = UserModel(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      createdAt: DateTime.now(),
    );
     final result = await getCurrentUserSession.call(userModel);
     result.fold((failure){
       Get.snackbar("error", failure.errorMessage.toString());
     }, (success){
       currentUser.value = success;
     });
  }

  // Future registeredGoogle () async {
  //   final userModel = UserModel(
  //     fullName: fullNameController.text.trim(),
  //     email: emailController.text.trim(),
  //     password: passwordController.text.trim(),
  //     createdAt: DateTime.now(),
  //   );
  //  final result =  await registeredWithGoogle.call(userModel);
  //  result.fold((error){
  //    AppSnackbar.show(title: "error message", message: error.errorMessage.toString());
  //  }, (success){
  //    currentUser.value = success;
  //    Get.toNamed(AppRoutes.bottomNavScreen);
  //  });
  // }


  Future<void> deletAccount() async {
    isDeletingAccount.value = true;
    final result = await deleteAccount.call();
    result.fold(
          (failure) {
            isDeletingAccount.value = false;
        Get.snackbar("error", failure.errorMessage.toString());
      },
          (success) {
            isDeletingAccount.value = false;
            emailController.clear();
            passwordController.clear();
        Get.offAllNamed(AppRoutes.signInScreen);
      });
  }
  Future<void> launchToWeb(String url) async {
    Uri uri = Uri.parse(url);
    if(!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication
    )){
      Get.snackbar("launch error", "url are invalid");
    }
  }

}
