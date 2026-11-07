import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/features/steps_screen/step_screen_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import '../../utils/app_buttons.dart';

class StepsScreen extends GetView<StepScreenController> {
  const StepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              children: [
                /// Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 4.5.h,
                        width: 4.5.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glass,
                        ),
                        child:  Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.textPrimary,
                          size: 18,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: AppText(
                          "Steps",
                          type: AppTextType.heading4,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(width: 4.5.h),
                  ],
                ),

                SizedBox(height: 3.h),

                /// Circular Progress
                Obx(() {
                  final percent =
                      controller.homeC.stepPercentValue.value.clamp(0.0, 1.0);
                  return CircularPercentIndicator(
                    radius: 14.h,
                    lineWidth: 10,
                    percent: percent,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColors.secondaryCyan,
                    backgroundColor: AppColors.border,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          controller.homeC.currentSteps.value.toString(),
                          type: AppTextType.xlSuperBold,
                          color: AppColors.textPrimary,
                        ),

                        SizedBox(height: .5.h),

                        AppText(
                          "Steps",
                          type: AppTextType.body,
                          color: AppColors.textPrimary,
                        ),

                        SizedBox(height: .5.h),

                        AppText(
                          "of ${controller.homeC.totalSteps.value.toInt()} goal",
                          type: AppTextType.caption,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  );
                }),

                SizedBox(height: 2.5.h),

                /// Percentage Change
                Obx(() {
                  final double change =
                      controller.percentChangeFromYesterday.value;
                  final bool isPositive = change >= 0;
                  final String sign = isPositive ? "+" : "";
                  final Color color =
                      isPositive ? AppColors.success : AppColors.danger;
                  final IconData icon =
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: color,
                        size: 18,
                      ),

                      SizedBox(width: 1.w),

                      AppText(
                        "$sign${change.toStringAsFixed(1)}%",
                        type: AppTextType.bodyBold,
                        color: color,
                      ),

                      SizedBox(width: 1.5.w),

                      AppText(
                        "from yesterday",
                        type: AppTextType.caption,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  );
                }),

                SizedBox(height: 2.5.h),

                /// Chart Card
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.glass,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        /// Toggle
                        Container(
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      controller.barChartIndex.value = 1;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border:
                                            controller.barChartIndex.value == 1
                                            ? const Border(
                                                bottom: BorderSide(
                                                  color:
                                                      AppColors.secondaryCyan,
                                                  width: 2,
                                                ),
                                              )
                                            : null,
                                      ),
                                      child: Center(
                                        child: AppText(
                                          "Week",
                                          type: AppTextType.bodyBold,
                                          color:
                                              controller.barChartIndex.value == 1
                                              ? AppColors.secondaryCyan
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Obx(() {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.barChartIndex.value = 2;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border:
                                            controller.barChartIndex.value == 2
                                            ? const Border(
                                                bottom: BorderSide(
                                                  color:
                                                      AppColors.secondaryCyan,
                                                  width: 2,
                                                ),
                                              )
                                            : null,
                                      ),
                                      child: Center(
                                        child: AppText(
                                          "Month",
                                          type: AppTextType.bodyBold,
                                          color:
                                              controller.barChartIndex.value == 2
                                              ? AppColors.secondaryCyan
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 3.h),

                        /// Bar Chart
                        showBarChart(),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                /// Button
                AppButtonWidget(
                  text: "Set Daily Target",
                  width: 100.w,
                  height: 6.5.h,
                  radius: 18,
                  isGradient: true,
                  gradientColor: AppColors.buttonGradient,
                  onPressed: () {
                    Get.toNamed(AppRoutes.setTargetScreen);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showBarChart() {
    return Obx(() {
      if (controller.barChartIndex.value == 1) {
        final weeklyData = controller.weeklySteps;
        final maxY = _calculateMaxY(weeklyData);

        return Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxY,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY > 0 ? (maxY / 4) : 2000,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.glassBorder.withOpacity(0.3),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppColors.surfaceSecondary,
                  tooltipBorder:
                        BorderSide(color: AppColors.border),
                  // tooltipRoundedRadius: 10,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final idx = group.x.toInt();
                    final label = idx < controller.weeklyDays.length
                        ? controller.weeklyDays[idx]
                        : "";
                    return BarTooltipItem(
                      "$label\n${rod.toY.toInt()} steps",
                        TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: maxY > 0 ? (maxY / 4) : 2000,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      String text;
                      if (value >= 1000) {
                        text = "${(value / 1000).toInt()}k";
                      } else {
                        text = value.toInt().toString();
                      }
                      return AppText(
                        text,
                        type: AppTextType.micro,
                        color: AppColors.textPrimary,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= controller.weeklyDays.length) {
                        return const SizedBox.shrink();
                      }
                      final isToday =
                          idx == controller.weeklyDays.length - 1;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AppText(
                          controller.weeklyDays[idx],
                          type: AppTextType.micro,
                          color: isToday
                              ? AppColors.secondaryCyan
                              : AppColors.textSecondary,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: getWeeklyBarData(),
            ),
          ),
        );
      } else {
        final monthlyData = controller.monthlySteps;
        final maxY = _calculateMaxY(monthlyData);

        return Expanded(
          child: BarChart(
            BarChartData(
              maxY: maxY,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY > 0 ? (maxY / 4) : 2000,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: AppColors.glassBorder.withOpacity(0.3),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppColors.surfaceSecondary,
                  tooltipBorder:
                      BorderSide(color: AppColors.glassBorder),
                  // tooltipRoundedRadius: 10,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final day = group.x.toInt() + 1;
                    return BarTooltipItem(
                      "Day $day\n${rod.toY.toInt()} steps",
                      TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: maxY > 0 ? (maxY / 4) : 2000,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      String text;
                      if (value >= 1000) {
                        text = "${(value / 1000).toInt()}k";
                      } else {
                        text = value.toInt().toString();
                      }
                      return AppText(
                        text,
                        type: AppTextType.micro,
                        color: AppColors.textSecondary,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final day = value.toInt() + 1;
                      final totalDays = controller.monthlySteps.length;
                      if (day == 1 ||
                          day == 5 ||
                          day == 10 ||
                          day == 15 ||
                          day == 20 ||
                          day == 25 ||
                          day == totalDays) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: AppText(
                            day.toString(),
                            type: AppTextType.micro,
                            color: AppColors.textSecondary,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              barGroups: getMonthlyData(),
            ),
          ),
        );
      }
    });
  }

  double _calculateMaxY(List<int> data) {
    int maxVal = data.isNotEmpty ? data.reduce((a, b) => a > b ? a : b) : 0;
    double goal = controller.homeC.totalSteps.value;
    double highest = maxVal > goal ? maxVal.toDouble() : goal;
    return highest > 0 ? (highest * 1.25) : 6000.0;
  }

  List<BarChartGroupData> getWeeklyBarData() {
    final weeklySteps = controller.weeklySteps;
    final goal = controller.homeC.totalSteps.value;

    return List.generate(
      weeklySteps.length,
      (index) {
        final double stepVal = weeklySteps[index].toDouble();
        final bool isToday = index == weeklySteps.length - 1;

        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: stepVal,
              width: 16,
              borderRadius: BorderRadius.circular(8),
              gradient: isToday
                  ? AppColors.successGradient
                  : AppColors.buttonGradient,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: goal,
                color: AppColors.border,
              ),
            ),
          ],
        );
      },
    );
  }

  List<BarChartGroupData> getMonthlyData() {
    final monthlySteps = controller.monthlySteps;
    final now = DateTime.now();

    return List.generate(
      monthlySteps.length,
      (index) {
        final double stepVal = monthlySteps[index].toDouble();
        final bool isToday = (index + 1) == now.day;

        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: stepVal,
              width: 6,
              borderRadius: BorderRadius.circular(4),
              gradient: isToday
                  ? AppColors.successGradient
                  : AppColors.buttonGradient,
            ),
          ],
        );
      },
    );
  }
}
