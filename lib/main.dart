import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_expance/controllers/home_cubit/home_cubit.dart';
import 'package:income_expance/controllers/tab_cubit/tab_cubit.dart';
import 'package:income_expance/core/local_db/hive_local.dart';
import 'package:income_expance/core/local_db/prefrence_utils.dart';
import 'package:income_expance/pages/splash.dart';
import 'package:income_expance/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('money');
  DbHelper.openBox();
  Sf.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your applicati7979on.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TabCubit(),
        ),
        BlocProvider(
          create: (context) => HomeCubit(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          // MonthYearPickerLocalizations.delegate,
        ],
        title: 'Income Expanse',
        theme: myTheme,
        home: const Splash(),
      ),
    );
  }
}
