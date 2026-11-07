  import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/utils/app_assets.dart';
import 'package:sizer/sizer.dart';


class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent
          ),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: controller.animationController,
                builder: (context, child){
                  return SlideTransition(
                    position: controller.animation,
                    child:  Column(
                      children: [
                        SizedBox(height: 25.h,),
                        Image.asset(
                            height: 20.h,
                            AppAssets.appLogo),
                        SizedBox(height: 3.h,),
                        AppText("Fitora", color: AppColors.textPrimary,fontSize: 30,),
                        SizedBox(height: 2.h,),
                        AppText("Move Better", color: AppColors.textPrimary,fontSize: 16,),

                        AppText("Live Stronger", color: AppColors.textPrimary,fontSize: 16,),
                        SizedBox(height: 5.h,),
                      ],
                    ),
                  );
                },),
              SizedBox(height: 5.h,),
              CircularProgressIndicator(color: AppColors.textPrimary,)
            ],
          )
        )));



  }
}