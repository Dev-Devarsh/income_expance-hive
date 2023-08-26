import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_expance/controllers/home_cubit/home_cubit.dart';
import 'package:income_expance/core/constants/common_strings.dart';
import 'package:income_expance/core/local_db/hive_local.dart';
import 'package:income_expance/core/local_db/prefrence_utils.dart';
import 'package:income_expance/pages/add_transaction.dart';
import 'package:income_expance/pages/models/transaction.dart';
import 'package:income_expance/pages/settings.dart';
import 'package:income_expance/pages/widgets/confirm_dialog.dart';
import 'package:income_expance/pages/widgets/info_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:income_expance/core/theme/static.dart' as Static;
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //

  Map? data;

  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  late HomeCubit _homeCubit;
  DateTime selectedMonth = DateTime.now();
  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    _tooltipBehavior = TooltipBehavior(enable: true, activationMode: ActivationMode.singleTap);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeCubit.getData(selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: Colors.grey[200],
      //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            CupertinoPageRoute(
              builder: (context) => const AddIncomeExpanseNoGradient(),
            ),
          )
              .then((value) {
            _homeCubit.getData(selectedMonth);
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            16.0,
          ),
        ),
        backgroundColor: Static.PrimaryColor,
        child: const Icon(
          Icons.add_outlined,
          size: 32.0,
        ),
      ),
      //
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) => current is FetchData,
        builder: (context, state) {
          if (state is FetchData) {
            return ListView(
              children: [
                //
                Padding(
                  padding: const EdgeInsets.all(
                    12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200.0,
                        child: Text(
                          "Welcome ${Sf.getString(Keys.name)}",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            color: Static.PrimaryMaterialColor[800],
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12.0,
                          ),
                          color: Colors.white70,
                        ),
                        padding: const EdgeInsets.all(
                          12.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => const Settings(),
                              ),
                            )
                                .then((value) {
                              _homeCubit.getData(selectedMonth);
                            });
                          },
                          child: const Icon(
                            Icons.settings,
                            size: 32.0,
                            color: Color(0xff3E454C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) => current is ChangeDate,
                  builder: (context, state) {
                    if (state is ChangeDate || state is FetchData) {
                      return selectMonth();
                    }
                    return Container();
                  },
                ),
                //
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.all(
                    12.0,
                  ),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Static.PrimaryColor,
                          Colors.blueAccent,
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          24.0,
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            24.0,
                          ),
                        ),
                        // color: Static.PrimaryColor,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: 8.0,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Total Balance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              // fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              if (state is FetchData || state is ChangeDate) {
                                return Text(
                                  'Rs ${_homeCubit.totalBalance}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 36.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              if (state is FetchData || state is ChangeDate) {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      cardIncome(
                                        _homeCubit.totalIncome.toString(),
                                      ),
                                      cardExpance(
                                        _homeCubit.totalExpance.toString(),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //

                const SizedBox(
                  height: 12.0,
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is FetchData || state is ChangeDate) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(
                              12.0,
                            ),
                            child: Text(
                              "${months[selectedMonth.month - 1]} ${selectedMonth.year}",
                              style: const TextStyle(
                                fontSize: 32.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          (_homeCubit.incomedata.isEmpty || _homeCubit.expansedata.isEmpty)
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 12.0,
                                  ),
                                  height: 300,
                                  width: double.maxFinite,
                                  margin: const EdgeInsets.all(
                                    12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Not Enough Data to render Chart",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 12.0,
                                  ),
                                  margin: const EdgeInsets.all(
                                    12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: SfCartesianChart(
                                    key: UniqueKey(),
                                    indicators: const [],
                                    // zoomPanBehavior: _zoomPanBehavior,
                                    tooltipBehavior: _tooltipBehavior,
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
                                          color: const Color.fromRGBO(51, 51, 51, 1),
                                        ),
                                      ),
                                    ),
                                    primaryXAxis: DateTimeAxis(
                                      axisBorderType: AxisBorderType.withoutTopAndBottom,
                                      majorGridLines: const MajorGridLines(width: 0),
                                      crossesAt: 0,
                                      isVisible: true,
                                      interactiveTooltip: const InteractiveTooltip(enable: true),
                                      labelAlignment: LabelAlignment.start,
                                      title: AxisTitle(
                                          textStyle:
                                              const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color.fromRGBO(51, 51, 51, 1))),
                                    ),
                                    enableMultiSelection: true,
                                    series: <ChartSeries>[
                                      LineSeries<IncomeData, DateTime>(
                                          name: "Income",
                                          sortFieldValueMapper: (datum, index) => datum.time.day,
                                          enableTooltip: true,
                                          dataSource: _homeCubit.incomedata,
                                          sortingOrder: SortingOrder.ascending,
                                          xValueMapper: (IncomeData data, int inx) => data.time,
                                          yValueMapper: (IncomeData data, int ind) => data.amount,
                                          markerSettings: const MarkerSettings(isVisible: true)),
                                      LineSeries<ExpanseData, DateTime>(
                                          name: "Expanse",
                                          enableTooltip: true,
                                          sortFieldValueMapper: (datum, index) => datum.time.day,
                                          dataSource: _homeCubit.expansedata,
                                          sortingOrder: SortingOrder.ascending,
                                          xValueMapper: (ExpanseData data, int inx) => data.time,
                                          yValueMapper: (ExpanseData data, int ind) => data.amount,
                                          markerSettings: const MarkerSettings(isVisible: true)),
                                    ],
                                  ),
                                ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                if (!(_homeCubit.incomedata.isEmpty && _homeCubit.expansedata.isEmpty))
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Recent Transactions",
                        style: TextStyle(
                          fontSize: 32.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                //
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is FetchData) {
                      log(''
                        // 'data ${state.data.map((e) => '${e.date.day} - ${e.date.month}')}',
                      );
                      if (state.data.isNotEmpty) {
                        return transectionList(state.data);
                      } else {
                        return Container();
                      }
                    }
                    return Container();
                  },
                ),
                //
                const SizedBox(
                  height: 60.0,
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

//
//
//
// Widget
//
//

  Widget transectionList(List<TransactionModel> data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        TransactionModel dataAtIndex;
        try {
          dataAtIndex = data[index];
        } catch (e) {
          dataAtIndex = TransactionModel(0, "", DateTime.now(), "");
        }
        if (dataAtIndex.date.month == selectedMonth.month) {
          if (dataAtIndex.type == "Income") {
            return incomeTile(
              dataAtIndex.amount,
              dataAtIndex.note,
              dataAtIndex.date,
              index,
            );
          } else {
            return deleteExpance(
              dataAtIndex.amount,
              dataAtIndex.note,
              dataAtIndex.date,
              index,
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: const EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green[700],
          ),
          margin: const EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cardExpance(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: const EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red[700],
          ),
          margin: const EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expance",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget deleteExpance(int value, String note, DateTime date, int index) {
    return InkWell(
      splashColor: Static.PrimaryMaterialColor[400],
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          deleteInfoSnackBar,
        );
      },
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. This action is irreversible. Do you want to continue ?",
        );
        if (answer != null && answer) {
          await DbHelper.deleteData(index);
          _homeCubit.getData(selectedMonth);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xffced4eb),
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_circle_up_outlined,
                          size: 28.0,
                          color: Colors.red[700],
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        const Text(
                          "Expance",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "${date.day} ${months[date.month - 1]} ",
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "- $value",
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        note,
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget incomeTile(int value, String note, DateTime date, int index) {
    return InkWell(
      splashColor: Static.PrimaryMaterialColor[400],
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          deleteInfoSnackBar,
        );
      },
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. This action is irreversible. Do you want to continue ?",
        );

        if (answer != null && answer) {
          await DbHelper.deleteData(index);
          _homeCubit.getData(selectedMonth);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xffced4eb),
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_down_outlined,
                      size: 28.0,
                      color: Colors.green[700],
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    const Text(
                      "Credit",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                //
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${date.day} ${months[date.month - 1]} ",
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                //
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "+ $value",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                //
                //
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    note,
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget selectMonth() {
    return Padding(
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
              color: Static.PrimaryColor,
            ),
            alignment: Alignment.center,
            child: Text(
              months[selectedMonth.month-1],
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
              ),
              alignment: Alignment.center,
              child: const Row(
                children: [
                  Icon(Icons.calendar_month, color: Static.PrimaryColor),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Select Month",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Static.PrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IncomeData {
  final int amount;
  final DateTime time;

  IncomeData({required this.amount, required this.time});
}

class ExpanseData {
  final int amount;
  final DateTime time;

  ExpanseData({required this.amount, required this.time});
}
