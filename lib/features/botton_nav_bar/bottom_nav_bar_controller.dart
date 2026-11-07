  import 'package:fitoraa/features/export.dart';

  class BottomNavBarController extends GetxController{

    final pages = [
          () =>   HomeScreen(),
          () => const ActivityScreen(),
          () => const HistoryScreen(),
          () => const ProfileScreen(),
    ];
    final RxInt currentIndex = 0.obs;
  }