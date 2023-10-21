import 'package:bloc/bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:income_expance/pages/home/home_tab.dart';
import 'package:income_expance/pages/models/transaction.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  Box box = Hive.box('money');
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpance = 0;
  List<ExpanseData> expansedata = [];
  List<IncomeData> incomedata = [];
  Future<List<TransactionModel>> fetch(DateTime time) async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      // return Future.value(box.toMap());
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        // print(element);
        items.add(
          TransactionModel(
            element['amount'] as int,
            element['note'],
            element['date'] as DateTime,
            element['type'],
          ),
        );
      });
      setIncomeData(items, time);
      setExpanseData(items, time);
      return items;
    }
  }
  //

  setExpanseData(List<TransactionModel> entireData, DateTime selectedMonth) {
    List<TransactionModel> tempdataSet = [];
    expansedata.clear();
    tempdataSet = entireData.where((e) => (e.date.month == selectedMonth.month && e.type == "Expance")).toList();

    // Sorting the list as per the date
    tempdataSet.sort((a, b) => a.date.day.compareTo(b.date.day));
    //
    for (var i = 0; i < tempdataSet.length; i++) {
      expansedata.add(ExpanseData(amount: tempdataSet[i].amount, time: tempdataSet[i].date));
    }
  }

  setIncomeData(List<TransactionModel> entireData, DateTime selectedMonth) {
    List<TransactionModel> tempdataSet = [];
    incomedata.clear();
    tempdataSet = entireData.where((e) => (e.date.month == selectedMonth.month && e.type == "Income")).toList();
    // Sorting the list as per the date
    tempdataSet.sort((a, b) => a.date.day.compareTo(b.date.day));
    //
    for (var i = 0; i < tempdataSet.length; i++) {
      incomedata.add(IncomeData(amount: tempdataSet[i].amount, time: tempdataSet[i].date));
    }
  }

  getTotalBalance(List<TransactionModel> entireData, DateTime selectedMonth) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpance = 0;
    for (TransactionModel data in entireData) {
      if (data.date.month == selectedMonth.month) {
        if (data.type == "Income") {
          totalBalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpance += data.amount;
        }
      }
    }
  }

  getData(DateTime date) async {
    final data = await fetch(date);
    getTotalBalance(data, date);
    emit(FetchData(data));
    Future.delayed(
      1000.milliseconds,
      () {
        emit(MokeState());
      },
    );
  }

  chnageMonth(DateTime date) {
    emit(ChangeDate());
    getData(date);
  }
}
