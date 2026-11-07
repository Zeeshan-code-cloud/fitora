import 'package:firebase_core/firebase_core.dart';
import 'package:fitoraa/core/networks/network_controller.dart';
import 'package:fitoraa/core/storage/notification_services/notification_services.dart';
import 'package:fitoraa/core/theme/dart_theme.dart';
import 'package:fitoraa/core/theme/light_theme.dart';
import 'package:fitoraa/core/theme/theme_controller.dart';
import 'package:fitoraa/features/auths_screens/binding/auth_binding.dart';
import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/firebase_options.dart';
import 'package:fitoraa/utils/app_font.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
  import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';
 import 'package:timezone/data/latest.dart' as tz;
 import 'core/storage/lacal_db/step_history_model.dart';


final webClientId = "903957334646-bnmv2cq2fulk4vv54drsiivq63nb1orj.apps.googleusercontent.com";

 void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // await GoogleSignIn.instance.initialize(clientId: webClientId);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(NetworkController(), permanent: true);
  tz.initializeTimeZones();
  await NotificationServices.initialize();
  await Hive.initFlutter();

  Hive.registerAdapter(
    StepHistoryModelAdapter(),
  );

  await Hive.openBox<StepHistoryModel>(
    'step_history',
  );
  Get.put(ThemeController(), permanent: true);
  // Register Auth dependencies once, permanently, before the app starts
  AuthBinding().dependencies();
  runApp(  MyApp());
}

class MyApp extends StatelessWidget {
    MyApp({super.key});
  final themeC = Get.find<ThemeController>();
   @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, _, _) {
        return Obx(
          () =>  GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Fitora',
            theme: AppLightTheme.theme,
            darkTheme: AppDarkTheme.theme,
            themeMode: themeC.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
            initialBinding: ProfileBinding(),
            initialRoute: AppRoutes.splashScreen,
            getPages: AppPages.routes,
            popGesture: true,
          ),
        );
      },
    );
  }
}
