import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_expance/controllers/home_cubit/home_cubit.dart';
import 'package:income_expance/core/constants/common_strings.dart';
import 'package:income_expance/core/local_db/hive_local.dart';
import 'package:income_expance/core/local_db/prefrence_utils.dart';
import 'package:income_expance/core/theme/static.dart';
import 'package:income_expance/pages/models/transaction.dart';
import 'package:income_expance/pages/settings.dart';
import 'package:income_expance/pages/widgets/confirm_dialog.dart';
import 'package:income_expance/pages/widgets/info_snackbar.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

DateTime selectedMonth = DateTime.now();

class _HomePageState extends State<HomePage> {
  Map? data;
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  late TooltipBehavior _tooltipBehavior;
  // late ZoomPanBehavior _zoomPanBehavior;
  late HomeCubit _homeCubit;
  @override
  void initState() {
    super.initState();
    // _zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    _tooltipBehavior = TooltipBehavior(enable: true, activationMode: ActivationMode.singleTap);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeCubit.getData(selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    return SingleChildScrollView(
        child: BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => current is FetchData,
      builder: (context, state) {
        if (state is FetchData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //
              Padding(
                padding: const EdgeInsets.all(
                  12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Animate(
                      key: UniqueKey(),
                      effects: const [MoveEffect(begin: Offset(0, 25))],
                      child: SizedBox(
                        width: 200.0,
                        child: Text(
                          "Welcome ${Sf.getString(Keys.name)}",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            color: PrimaryMaterialColor[800],
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Animate(
                      key: UniqueKey(),
                      effects: const [ScaleEffect()],
                      child: Container(
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
                    ),
                  ],
                ),
              ),
              //
              BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (previous, current) => current is ChangeDate || current is FetchData,
                builder: (context, state) {
                  if (state is ChangeDate || state is FetchData) {
                    return Animate(key: UniqueKey(), effects: const [ScaleEffect()], child: selectMonth());
                  }
                  return Container();
                },
              ),
              //
              Animate(
                key: UniqueKey(),
                effects: const [ScaleEffect()],
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.all(
                    12.0,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        PrimaryColor,
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
                      // color: PrimaryColor,
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
                        ).animate().addEffect(
                              FadeEffect(delay: 500.milliseconds),
                            ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        BlocBuilder<HomeCubit, HomeState>(
                          buildWhen: (previous, current) => current is ChangeDate || current is FetchData,
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
                              ).animate().addEffect(
                                    FadeEffect(delay: 500.milliseconds),
                                  );
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        BlocBuilder<HomeCubit, HomeState>(
                          buildWhen: (previous, current) => current is ChangeDate || current is FetchData,
                          builder: (context, state) {
                            if (state is FetchData || state is ChangeDate) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Animate(
                                      key: UniqueKey(),
                                      effects: [
                                        FadeEffect(delay: 500.milliseconds),
                                      ],
                                      child: cardIncome(
                                        _homeCubit.totalIncome.toString(),
                                      ),
                                    ),
                                    Animate(
                                      key: UniqueKey(),
                                      effects: [
                                        FadeEffect(delay: 500.milliseconds),
                                      ],
                                      child: cardExpance(
                                        _homeCubit.totalExpance.toString(),
                                      ),
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
              if (!(_homeCubit.incomedata.isEmpty && _homeCubit.expansedata.isEmpty))
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Recent Transactions",
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w900,
                          )),
                      Text(
                        "(${months[selectedMonth.month - 1]} ${selectedMonth.year})",
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    ],
                  ),
                ),
              //
              BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (previous, current) => current is FetchData,
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
    ));
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
            return Animate(
              effects: [FadeEffect(delay: ((index+1)*200).milliseconds)],
              child: incomeTile(
                dataAtIndex.amount,
                dataAtIndex.note,
                dataAtIndex.date,
                index,
              ),
            );
          } else {
            return Animate(
              effects: [FadeEffect(delay: ((index + 1) * 200).milliseconds)],
              child: deleteExpance(
                dataAtIndex.amount,
                dataAtIndex.note,
                dataAtIndex.date,
                index,
              ),
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
      splashColor: PrimaryMaterialColor[400],
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
      splashColor: PrimaryMaterialColor[400],
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
