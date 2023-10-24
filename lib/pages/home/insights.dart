import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_expance/controllers/home_cubit/home_cubit.dart';
import 'package:income_expance/pages/home/home_tab.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late TooltipBehavior _tooltipBehavior;
  late HomeCubit _homeCubit;
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });
  @override
  void initState() {
    super.initState();
    // _zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    _tooltipBehavior = TooltipBehavior(enable: true, activationMode: ActivationMode.singleTap);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeCubit.getData(selectedMonth);
       SQMTelPoints.add(FlSpot(xValue, widget.SQMTELValue));
    });
  }

  @override
  Widget build(BuildContext context) {
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    return const Column(
      children: [
        // BlocBuilder<HomeCubit, HomeState>(
        //   buildWhen: (previous, current) => current is FetchData,
        //   builder: (context, state) {
        //     // return Flexible(
        //     //   flex: 50,
        //     //   child: Container(
        //     //     padding: const EdgeInsets.symmetric(
        //     //       vertical: 20.0,
        //     //       horizontal: 12.0,
        //     //     ),
        //     //     margin: const EdgeInsets.all(
        //     //       12.0,
        //     //     ),
        //     //     decoration: BoxDecoration(
        //     //       // color: Colors.black45,
        //     //       borderRadius: BorderRadius.circular(8),
        //     //       boxShadow: [
        //     //         BoxShadow(
        //     //           color: Colors.white.withOpacity(0.5),
        //     //           spreadRadius: 5,
        //     //           blurRadius: 7,
        //     //           offset: const Offset(0, 3), // changes position of shadow
        //     //         ),
        //     //       ],
        //     //     ),
        //     //     child: SfCartesianChart(
        //     //       indicators: const [],
        //     //       // zoomPanBehavior: _zoomPanBehavior,
        //     //       tooltipBehavior: _tooltipBehavior,
        //     //       margin: const EdgeInsets.only(top: 10),
        //     //       enableAxisAnimation: true,
        //     //       legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        //     //       primaryYAxis: NumericAxis(
        //     //         edgeLabelPlacement: EdgeLabelPlacement.shift,
        //     //         majorGridLines: const MajorGridLines(width: 0),
        //     //         crossesAt: 0,
        //     //         interactiveTooltip: const InteractiveTooltip(enable: true),
        //     //         axisBorderType: AxisBorderType.withoutTopAndBottom,
        //     //         title: AxisTitle(
        //     //           textStyle: const TextStyle(
        //     //             fontSize: 11,
        //     //             fontWeight: FontWeight.w500,
        //     //             color: Color.fromRGBO(51, 51, 51, 1),
        //     //           ),
        //     //         ),
        //     //       ),
        //     //       primaryXAxis: DateTimeAxis(
        //     //         axisBorderType: AxisBorderType.withoutTopAndBottom,
        //     //         majorGridLines: const MajorGridLines(width: 0),
        //     //         crossesAt: 0,
        //     //         isVisible: true,
        //     //         interactiveTooltip: const InteractiveTooltip(enable: true),
        //     //         labelAlignment: LabelAlignment.start,
        //     //         title: AxisTitle(textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color.fromRGBO(51, 51, 51, 1))),
        //     //       ),
        //     //       enableMultiSelection: true,
        //     //       series: <ChartSeries>[
        //     //         LineSeries<IncomeData, DateTime>(
        //     //             name: "Income",
        //     //             sortFieldValueMapper: (datum, index) => datum.time.day,
        //     //             enableTooltip: true,
        //     //             dataSource: _homeCubit.incomedata,
        //     //             sortingOrder: SortingOrder.ascending,
        //     //             xValueMapper: (IncomeData data, int inx) => data.time,
        //     //             yValueMapper: (IncomeData data, int ind) => data.amount,
        //     //             markerSettings: const MarkerSettings(isVisible: true)),
        //     //         LineSeries<ExpanseData, DateTime>(
        //     //             name: "Expanse",
        //     //             enableTooltip: true,
        //     //             sortFieldValueMapper: (datum, index) => datum.time.day,
        //     //             dataSource: _homeCubit.expansedata,
        //     //             sortingOrder: SortingOrder.ascending,
        //     //             xValueMapper: (ExpanseData data, int inx) => data.time,
        //     //             yValueMapper: (ExpanseData data, int ind) => data.amount,
        //     //             markerSettings: const MarkerSettings(isVisible: true)),
        //     //       ],
        //     //     ),
        //     //   ),
        //     // );
        //   },
        // ),
        // Flexible(
        //   flex: 50,
        //   child: LineChart(
        //    LineChartData(

        //    )
        //   ),
        // )
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
