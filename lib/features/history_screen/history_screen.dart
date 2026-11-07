import 'package:fitoraa/core/theme/theme_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';
import '../../enums.dart';
import '../export.dart';

class HistoryScreen extends GetView<HistoryController> {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Obx(
        () {
          Get.find<ThemeController>().isDarkMode.value;
          return Container(
            height: double.infinity,
            decoration:   BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 2.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Top Filter
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Obx(
                              () => PopupMenuButton<HistoryFilter>(
                            color: AppColors.surface,
                            elevation: 12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            onSelected: (value) {
                              controller.setFilter(value);
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: HistoryFilter.thisWeek,
                                child: AppText(
                                  "This Week",
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              PopupMenuItem(
                                value: HistoryFilter.lastWeek,
                                child: AppText(
                                  "Last Week",
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              PopupMenuItem(
                                value: HistoryFilter.thisMonth,
                                child: AppText(
                                  "This Month",
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.3.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.glass,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.border,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppText(
                                    controller.selectedFilter.value ==
                                        HistoryFilter.thisWeek
                                        ? "This Week"
                                        : controller.selectedFilter.value ==
                                        HistoryFilter.lastWeek
                                        ? "Last Week"
                                        : "This Month",
                                    type: AppTextType.bodyBold,
                                    color: AppColors.textPrimary,
                                  ),
                                  SizedBox(width: 2.w),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      /// Stats Cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _statsSteps(
                            title: "Steps",
                            unit: "steps",
                          ),
                          SizedBox(width: 3.w),
                          _statsCalories(
                            title: "Calories",
                            unit: "kcal",
                          ),
                          SizedBox(width: 3.w),
                          _statsDistance(
                            title: "Distance",
                            unit: "km",
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      /// Activity Overview
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppColors.glass,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.border,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "Activity Overview",
                              type: AppTextType.bodyBold,
                              color: AppColors.textPrimary,
                            ),
                            SizedBox(height: 3.h),
                            SizedBox(
                              height: 35.h,
                              child: Obx(
                                    ()   => LineChart(
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.easeInCubic,
                                  LineChartData(

                                    minY: 0,
                                    maxY: controller.getMaxY(
                                        days: controller.selectedFilter.value == HistoryFilter.thisWeek
                                            ? 7
                                            : controller.selectedFilter.value == HistoryFilter.lastWeek
                                            ? 14
                                            : 30),


                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: true,
                                      horizontalInterval: 1000,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: AppColors.glass,
                                          strokeWidth: 2,
                                        );
                                      },
                                      getDrawingVerticalLine: (value) {
                                        return FlLine(
                                          color: AppColors.textPrimary,
                                          strokeWidth: .5,
                                        );
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    titlesData: FlTitlesData(
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                          reservedSize: 40,
                                        ),
                                      ),

                                      bottomTitles: AxisTitles(

                                        sideTitles: SideTitles(

                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            final days = controller.selectedFilter.value == HistoryFilter.thisWeek
                                                ? 7
                                                : controller.selectedFilter.value == HistoryFilter.lastWeek
                                                ? 14
                                                : 30;

                                            return AppText(
                                              controller.getBottomLabel(value.toInt(), days),
                                            );

                                          },
                                        ),
                                      ),
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: controller.getChartSpots(
                                          days: controller.selectedFilter.value == HistoryFilter.thisWeek
                                              ? 7
                                              : controller.selectedFilter.value == HistoryFilter.lastWeek
                                              ? 14
                                              : 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 3.h),

                      /// Calendar
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

  Widget showHistoryDatePicker () {
    return GestureDetector(

      onTap : () {
        controller.showHistoryDate.value = false;
      },
        child: Container(
          width: 30.w,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppColors.glass,

          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),

        ),
        child: Column(
          children: List.generate(6, (index){
            return Column(
              children: [
                AppText("Week", fontSize: 16,fontWeight: FontWeight.bold,color: AppColors.textPrimary,),
                Container(height: 1,width: 15.w,decoration: BoxDecoration(color: AppColors.divider),),
                SizedBox(height: 2.w,)
              ],
            );
          }),
        ),
      ),
    );
  }
  Widget _statsSteps({
    required String title,
    required String unit,
  }) {
    return Container(
      width: 27.w,
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          AppText(
            title,
            type: AppTextType.micro,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 1.h),
          Obx(
            () {
              return AppText(
                controller.steps.value.toString(),
                type: AppTextType.heading2,
                fontSize: 15,
                color: AppColors.textPrimary,
              );
            },
          ),
          SizedBox(height: .5.h),
          AppText(
            unit,
            type: AppTextType.micro,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _statsCalories({
    required String title,
    required String unit,
  }) {
    return Container(
      width: 27.w,
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          AppText(
            title,
            type: AppTextType.micro,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 1.h),
          Obx(
            () {
              return AppText(
                controller.calories.value.toStringAsFixed(1),
                type: AppTextType.heading2,
                fontSize: 15,
                color: AppColors.textPrimary,
              );
            },
          ),
          SizedBox(height: .5.h),
          AppText(
            unit,
            type: AppTextType.micro,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _statsDistance({
    required String title,
    required String unit,
  }) {
    return Container(
      width: 27.w,
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          AppText(
            title,
            type: AppTextType.micro,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 1.h),
          Obx(
            () {
              return AppText(
                controller.distance.value.toStringAsFixed(1),
                fontSize: 15,
                type: AppTextType.heading2,
                color: AppColors.textPrimary,
              );
            },
          ),
          SizedBox(height: .5.h),
          AppText(
            unit,
            type: AppTextType.micro,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}
