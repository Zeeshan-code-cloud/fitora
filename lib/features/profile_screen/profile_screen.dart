import 'dart:io';
import 'package:fitoraa/core/theme/theme_controller.dart';
import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/utils/app_assets.dart';
import 'package:fitoraa/utils/app_text_field.dart';
import 'package:fitoraa/utils/show_custom_dialog.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:sizer/sizer.dart';
import '../../utils/app_buttons.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          Get.find<ThemeController>().isDarkMode.value;
          return SingleChildScrollView(
            child: Container(
              height: 103.h,
              decoration:   BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 2.h,
                  ),
                  child: Column(
                    children: [
                      /// Profile Header
                      Container(
                        padding: EdgeInsets.only(top : 2.w, right: 2.w, left: 2.w),
                        decoration: BoxDecoration(
                          gradient: AppColors.purpleGradient,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [

                                SizedBox(width: 4.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [
                                          Obx(
                                                  () {
                                                if(controller.profileImage.value.isNotEmpty && File(controller.profileImage.value).existsSync()){
                                                  return   CircleAvatar(
                                                    radius: 35,
                                                    backgroundColor: Colors.white.withOpacity(0.1),
                                                    backgroundImage: FileImage(File(controller.profileImage.value)),
                                                  );
                                                }
                                                return  CircleAvatar(
                                                  radius: 35,
                                                  backgroundColor:
                                                  Colors.white.withOpacity(0.1),
                                                  child: ClipOval(
                                                      clipBehavior: Clip.hardEdge,
                                                      child: Center(child: Image.asset(AppAssets.profileAvatar, fit: BoxFit.contain,))),
                                                );
                                              }

                                          ),
                                          GestureDetector(

                                            onTap : () async {

                                              final nameController = TextEditingController(
                                                text: controller.authC.currentUser.value?.fullName ?? "",
                                              );

                                              await showProfileDialog(nameController: nameController);

                                            },
                                            child: Container(
                                              height: 4.h,
                                              width: 4.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white12,
                                              ),
                                              child: const Icon(
                                                Icons.edit_outlined,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h,),
                                      Obx(
                                            () =>  AppText(
                                          controller.authC.currentUser.value!.fullName,
                                          type: AppTextType.heading3,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),

                                      SizedBox(height: 1.h),

                                      Obx(
                                            () =>  AppText(
                                          controller.authC.currentUser.value!.email,
                                          type: AppTextType.caption,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),

                            SizedBox(height: 1.5.h),

                          ],
                        ),
                      ),

                      SizedBox(height: 1.5.h),

                      /// Account Section
                      _sectionTitle("General"),

                      SizedBox(height: 1.h),

                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.glass,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.border,
                          ),
                        ),
                        child: Column(
                          children: [
                            Obx(
                                  () =>  SwitchListTile(
                                value: controller.toggledNotification.value,
                                activeColor: AppColors.success,
                                secondary: Icon(
                                  Icons.notifications_none,
                                  color:
                                  AppColors.textPrimary,
                                ),
                                title: AppText(
                                  "Notifications",
                                  type:
                                  AppTextType.bodyBold,
                                  color:
                                  AppColors.textPrimary,
                                ),
                                onChanged: (value) {
                                  controller.toggleNotification(value);

                                },
                              ),
                            ),
                            Obx(
                                  () =>  SwitchListTile(
                                value: controller.themeC.isDarkMode.value,
                                activeColor: AppColors.success,
                                secondary: Icon(
                                  Icons.mode_night_outlined,
                                  color:
                                  AppColors.textPrimary,
                                ),
                                title: AppText(
                                  "Dark Theme",
                                  type: AppTextType.bodyBold,
                                  color: AppColors.textPrimary,
                                ),
                                onChanged: (value) {
                                  controller.themeC.toggledTheme();

                                },
                              ),
                            ),


                          ],
                        ),
                      ),

                      SizedBox(height: 1.5.h),

                      /// Support
                      _sectionTitle("Support"),

                      SizedBox(height: 1.h),

                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.glass,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.border,
                          ),
                        ),
                        child: Column(
                          children: [

                            _supportTiles(
                              icon: Icons.privacy_tip_outlined,
                              title: "Privacy Policy",
                              onTap: ()  {
                                controller.launchToWeb("https://zeeshan-code-cloud.github.io/fitora_privacy/");
                              },
                            ),

                            Divider(
                              color: AppColors.textSecondary.withOpacity(0.3),
                              height: 1,
                            ),

                            _supportTiles(
                              icon: Icons.description_outlined,
                              title: "Terms & Conditions",
                              onTap: () {
                                controller.launchToWeb("https://zeeshan-code-cloud.github.io/fitora_terms/");
                              },
                            ),

                            Divider(
                              color: AppColors.textSecondary.withOpacity(0.3),
                              height: 1,
                            ),

                            _supportTiles(
                              icon: Icons.star_outline_rounded,
                              title: "Rate Fitora",
                              onTap: () {
                                controller.launchPlayStore("com.zeetech.fitora.app.fitoraa");
                              },
                            ),

                            Divider(
                              color: AppColors.textSecondary.withOpacity(0.3),
                              height: 1,
                            ),

                            _supportTiles(
                              icon: Icons.info_outline,
                              title: "About Fitora",
                              onTap: () {
                                controller.launchToWeb("https://zeeshan-code-cloud.github.io/fitora_about/");
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h,),

                      /// Logout Button
                      AppButtonWidget(
                        text: "Log Out",
                        width: 100.w,
                        height: 6.5.h,
                        radius: 18,
                        buttonColor:
                        Colors.transparent,
                        borderColor:
                        AppColors.danger,
                        textColor:
                        AppColors.danger,
                        prefixIcon: Icon(Icons.logout,
                          color: AppColors.danger,
                          size: 20,
                        ),
                        onPressed: () {
                         ShowCustomDialog.showCustomDialog(
                           context: context,
                           icon: Icons.logout_rounded,
                           iconColor: AppColors.danger,
                           title: "Log Out?",
                           content:
                           "Are you sure you want to log out from your account?",
                           confirmText: "Log Out",
                           cancelText: "Cancel",
                           confirmButtonColor: AppColors.danger,
                           confirmTextColor: AppColors.textPrimary,
                           onConfirm: controller.authC.logOut,);
                        },
                      ),  SizedBox(height: 2.h,),

                      /// Logout Button
                      AppButtonWidget(
                        loader: controller.authC.isDeletingAccount.value,
                        text: "Delete Account",
                        width: 100.w,
                        height: 6.5.h,
                        radius: 18,
                        buttonColor:
                        Colors.transparent,
                        borderColor:
                        AppColors.danger,
                        textColor:
                        AppColors.danger,
                        prefixIcon: Icon(
                          Icons.delete,
                          color: AppColors.danger,
                          size: 20,
                        ),
                        onPressed: () {
                          ShowCustomDialog.showCustomDialog(
                            context: context,
                            icon: Icons.delete_forever,
                            iconColor: Colors.red,
                            title: "Delete Account",
                            content:
                            "This action cannot be undone. Do you want to continue?",
                            confirmText: "Delete",
                            confirmButtonColor: Colors.red,
                            onConfirm: () async  {
                            await   controller.authC.deletAccount();

                            },
                          );
                         },
                      ),

                     ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AppText(
        title,
        type: AppTextType.bodyBold,
        color: AppColors.textPrimary,
      ),
    );
  }




 
  Future<Widget> showProfileDialog({required TextEditingController nameController}) async {
    return SizedBox(
      child: await  Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: AppColors.backgroundGradient,
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Profile Image
                  Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(
                              () {
                            if(controller.profileImage.value.isNotEmpty && File(controller.profileImage.value).existsSync()){
                              return   CircleAvatar(

                                radius: 6.h,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                backgroundImage: FileImage(File(controller.profileImage.value)),
                              );
                            }
                            return  CircleAvatar(
                              radius: 6.h,
                              backgroundColor:
                              Colors.white.withOpacity(0.1),
                              child: Icon(Icons.person, size: 35,),
                            );
                          }

                      ),

                      GestureDetector(
                        onTap: () async {
                          await controller.selectImageFromGallery();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  AppText(
                    "Edit Profile",
                    type: AppTextType.heading3,
                    color: AppColors.textPrimary,
                  ),

                  const SizedBox(height: 20),

                  AppFormField(
                    isFilled: true,
                    textColor: AppColors.textPrimary,
                    hintTextColor: AppColors.textSecondary,
                    filledColor: AppColors.textSecondary,
                    showBorder: true,
                    borderColor: AppColors.border,
                    title: 'full name',
                    textEditingController: nameController,
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: AppButtonWidget(
                          height: 6.h,
                          text: "Cancel",
                          textColor: AppColors.textPrimary,
                          buttonColor: AppColors.secondaryCyan,
                          borderColor:
                          Colors.white.withOpacity(0.15),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Obx(
                              () {
                            return AppButtonWidget(
                              loader: controller.authC.isUpdating.value,
                              height: 6.h,
                              text: "Update",
                              onPressed:  (){
                                final updatedUser = controller.authC.currentUser.value!.copyWith(
                                    fullName: nameController.text.trim()
                                );
                                controller.authC.updateProfile(updatedUser.fullName);
                                Get.back();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget _supportTiles({
    required IconData icon,
    required String title,
    String? value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 2.h,
        ),
        child: Row(
          children: [
            /// Icon Container
            Container(
              height: 5.h,
              width: 5.h,
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),

            SizedBox(width: 4.w),

            /// Title
            Expanded(
              child: AppText(
                title,
                type: AppTextType.body,
                color: AppColors.textPrimary,
              ),
            ),

            /// Value
            if (value != null)
              AppText(
                value,
                type: AppTextType.caption,
                color: AppColors.textSecondary,
              ),

            SizedBox(width: 2.w),

            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

}
