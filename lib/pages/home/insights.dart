import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_expance/controllers/home_cubit/home_cubit.dart';
import 'package:income_expance/core/theme/static.dart';
import 'package:income_expance/pages/home/home_tab.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late TooltipBehavior _tooltipIncomeBehavior;
  late TooltipBehavior _tooltipExpanseBehavior;
  late HomeCubit _homeCubit;
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });
  @override
  void initState() {
    super.initState();
    // _zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    _tooltipIncomeBehavior = TooltipBehavior(enable: true, activationMode: ActivationMode.singleTap);
    _tooltipExpanseBehavior = TooltipBehavior(enable: true, activationMode: ActivationMode.singleTap);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeCubit.getData(selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    return Column(
      children: [
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) => current is FetchData,
          builder: (context, state) {
            return Column(
              children: [
                Animate(
                  effects: const [ScaleEffect()],
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50.0,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                            boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black26, spreadRadius: 1, offset: Offset(0, 2))],
                            color: PrimaryColor,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            months[selectedMonth.month - 1],
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final picked = await showMonthPicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2012),
                              lastDate: DateTime(2099),
                            );
                            if (picked != null && picked != selectedMonth) {
                              selectedMonth = picked;
                              _homeCubit.chnageMonth(selectedMonth);
                            }
                          },
                          child: Container(
                            height: 50.0,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
                              color: Colors.white,
                              boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black26, spreadRadius: 1, offset: Offset(0, 2))],
                            ),
                            alignment: Alignment.center,
                            child: const Row(
                              children: [
                                Icon(Icons.calendar_month, color: PrimaryColor),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Select Month",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: PrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Animate(
                  effects: const [FadeEffect()],
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                    decoration: BoxDecoration(
                      // color: Colors.black45,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SfCartesianChart(
                      indicators: const [],
                      // zoomPanBehavior: _zoomPanBehavior,
                      tooltipBehavior: _tooltipIncomeBehavior,
                      margin: const EdgeInsets.only(top: 10),
                      enableAxisAnimation: true,
                      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                      primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        majorGridLines: const MajorGridLines(width: 0),
                        crossesAt: 0,
                        interactiveTooltip: const InteractiveTooltip(enable: true),
                        axisBorderType: AxisBorderType.withoutTopAndBottom,
                        title: AxisTitle(
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(51, 51, 51, 1),
                          ),
                        ),
                      ),
                      plotAreaBorderWidth: 0,
                      primaryXAxis: DateTimeAxis(
                        axisBorderType: AxisBorderType.withoutTopAndBottom,
                        majorGridLines: const MajorGridLines(width: 0),
                        crossesAt: 0,
                        isVisible: true,
                        interactiveTooltip: const InteractiveTooltip(enable: true),
                        labelAlignment: LabelAlignment.start,
                        title: AxisTitle(textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color.fromRGBO(51, 51, 51, 1))),
                      ),
                      enableMultiSelection: true,
                      series: <ChartSeries>[
                        SplineAreaSeries<IncomeData, DateTime>(
                          name: "Income",
                          enableTooltip: true,
                          splineType: SplineType.cardinal,
                          cardinalSplineTension: 0.9,
                          dataSource: _homeCubit.incomedata,
                          // color: const Color(0xFFA0E9FF),
                          borderColor: const Color(0xFF15AA5C),
                          borderWidth: 2,
                          gradient: const LinearGradient(tileMode: TileMode.mirror, begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                            Color(0xFFC2F2D3),
                            Colors.white,
                          ]),
                          sortingOrder: SortingOrder.ascending,
                          sortFieldValueMapper: (datum, index) => datum.time.day,
                          xValueMapper: (IncomeData data, int inx) => data.time,
                          yValueMapper: (IncomeData data, int ind) => data.amount,
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Animate(
                  effects: const [ FadeEffect()],
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                    decoration: BoxDecoration(
                      // color: Colors.black45,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SfCartesianChart(
                      indicators: const [],
                      // zoomPanBehavior: _zoomPanBehavior,
                      tooltipBehavior: _tooltipExpanseBehavior,
                      margin: const EdgeInsets.only(top: 10),
                      enableAxisAnimation: true,
                      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                      primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        majorGridLines: const MajorGridLines(width: 0),
                        crossesAt: 0,
                        interactiveTooltip: const InteractiveTooltip(enable: true),
                        axisBorderType: AxisBorderType.withoutTopAndBottom,
                        borderColor: Colors.transparent,
                        title: AxisTitle(
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(51, 51, 51, 1),
                          ),
                        ),
                      ),
                      primaryXAxis: DateTimeAxis(
                        axisBorderType: AxisBorderType.withoutTopAndBottom,
                        majorGridLines: const MajorGridLines(width: 0),
                        crossesAt: 0,
                        borderColor: Colors.transparent,
                        isVisible: true,
                        interactiveTooltip: const InteractiveTooltip(enable: true),
                        labelAlignment: LabelAlignment.start,
                        title: AxisTitle(textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color.fromRGBO(51, 51, 51, 1))),
                      ),
                      plotAreaBorderWidth: 0,
                      series: [
                        SplineAreaSeries<ExpanseData, DateTime>(
                            name: "Expanse",
                            enableTooltip: true,
                            borderWidth: 2,
                            sortFieldValueMapper: (datum, index) => datum.time.day,
                            dataSource: _homeCubit.expansedata,
                            sortingOrder: SortingOrder.ascending,
                            splineType: SplineType.cardinal,
                            borderColor: const Color(0XFFFF3534).withOpacity(0.5),
                            gradient:
                                const LinearGradient(tileMode: TileMode.mirror, begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                              Color(0xFFFFCDD3),
                              Colors.white,
                            ]),
                            cardinalSplineTension: 10,
                            xValueMapper: (ExpanseData data, int inx) => data.time,
                            yValueMapper: (ExpanseData data, int ind) => data.amount,
                            markerSettings: const MarkerSettings(isVisible: true)),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
        // Flexible(
        //     flex: 50,
        //     child: LineChart(
        //       LineChartData(
        //         lineTouchData: LineTouchData(
        //           enabled: true,
        //           handleBuiltInTouches: false,
        //           // touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
        //           //   if (response == null || response.lineBarSpots == null) {
        //           //     return;
        //           //   }
        //           //   // if (event is FlTapUpEvent) {
        //           //   //   final spotIndex =
        //           //   //       response.lineBarSpots!.first.spotIndex;
        //           //   //   showingTooltipOnSpots.clear();
        //           //   //   setState(() {
        //           //   //     showingTooltipOnSpots.add(spotIndex);
        //           //   //   });
        //           //   // }
        //           // },
        //           mouseCursorResolver: (FlTouchEvent event, LineTouchResponse? response) {
        //             if (response == null || response.lineBarSpots == null) {
        //               return SystemMouseCursors.basic;
        //             }
        //             return SystemMouseCursors.click;
        //           },
        //           getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
        //             return spotIndexes.map((index) {
        //               return TouchedSpotIndicatorData(
        //                 const FlLine(
        //                   color: Colors.transparent,
        //                 ),
        //                 FlDotData(
        //                   show: true,
        //                   getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
        //                     radius: 3,
        //                     color: Colors.white,
        //                     strokeWidth: 3,
        //                     strokeColor: AppColors.secondaryColor1,
        //                   ),
        //                 ),
        //               );
        //             }).toList();
        //           },
        //           touchTooltipData: LineTouchTooltipData(
        //             tooltipBgColor: AppColors.secondaryColor1,
        //             tooltipRoundedRadius: 20,
        //             getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
        //               return lineBarsSpot.map((lineBarSpot) {
        //                 return LineTooltipItem(
        //                   "${lineBarSpot.x.toInt()} mins ago",
        //                   const TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 10,
        //                     fontWeight: FontWeight.bold,
        //                   ),
        //                 );
        //               }).toList();
        //             },
        //           ),
        //         ),
        //         lineBarsData: lineBarsData1,
        //         minY: -0.5,
        //         maxY: 110,
        //         titlesData: FlTitlesData(
        //             show: true,
        //             leftTitles: const AxisTitles(),
        //             topTitles: const AxisTitles(),
        //             bottomTitles: AxisTitles(
        //               sideTitles: bottomTitles,
        //             ),
        //             rightTitles: AxisTitles(
        //               sideTitles: rightTitles,
        //             )),
        //         gridData: FlGridData(
        //           show: true,
        //           drawHorizontalLine: true,
        //           horizontalInterval: 25,
        //           drawVerticalLine: false,
        //           getDrawingHorizontalLine: (value) {
        //             return FlLine(
        //               color: AppColors.whiteColor.withOpacity(0.15),
        //               strokeWidth: 2,
        //             );
        //           },
        //         ),
        //         borderData: FlBorderData(
        //           show: true,
        //           border: Border.all(
        //             color: Colors.transparent,
        //           ),
        //         ),
        //       ),
        //     ))
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = const TextStyle(
      color: Colors.pinkAccent,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Sun', style: style);
        break;
      case 2:
        text = Text('Mon', style: style);
        break;
      case 3:
        text = Text('Tue', style: style);
        break;
      case 4:
        text = Text('Wed', style: style);
        break;
      case 5:
        text = Text('Thu', style: style);
        break;
      case 6:
        text = Text('Fri', style: style);
        break;
      case 7:
        text = Text('Sat', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );
  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_2,
      ];

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Colors.cyan.withOpacity(0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
        ),
        spots: const [
          FlSpot(1, 80),
          FlSpot(2, 50),
          FlSpot(3, 90),
          FlSpot(4, 40),
          FlSpot(5, 80),
          FlSpot(6, 35),
          FlSpot(7, 60),
        ],
      );

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 20,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 20:
        text = '20%';
        break;
      case 40:
        text = '40%';
        break;
      case 60:
        text = '60%';
        break;
      case 80:
        text = '80%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text,
        style: const TextStyle(
          color: Colors.blueGrey,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }
}

class AppColors {
  static const primaryColor1 = Color(0xFF92A3FD);
  static const primaryColor2 = Color(0xFF9DCEFF);

  static const secondaryColor1 = Color(0xFFC58BF2);
  static const secondaryColor2 = Color(0xFFEEA4CE);

  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF1D1617);
  static const grayColor = Color(0xFF7B6F72);
  static const lightGrayColor = Color(0xFFF7F8F8);
  static const midGrayColor = Color(0xFFADA4A5);

  static List<Color> get primaryG => [primaryColor1, primaryColor2];
  static List<Color> get secondaryG => [secondaryColor1, secondaryColor2];
}
