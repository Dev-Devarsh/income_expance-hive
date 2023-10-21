import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:income_expance/controllers/home_cubit/home_cubit.dart';
import 'package:income_expance/controllers/tab_cubit/tab_cubit.dart';
import 'package:income_expance/core/theme/static.dart';
import 'package:income_expance/pages/home/add_transaction.dart';
import 'package:income_expance/pages/home/home_tab.dart';
import 'package:income_expance/pages/home/insights.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController(initialPage: 0);
  late TabCubit _tabCubit;

  late HomeCubit _homeCubit;

  int initialPage = 0;
  @override
  Widget build(BuildContext context) {
    _tabCubit = BlocProvider.of<TabCubit>(context);
    _homeCubit = BlocProvider.of<HomeCubit>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      // backgroundColor: Colors.grey[200],

      //
      body: PageView(
        allowImplicitScrolling: false, //
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          initialPage = value;
        },
        children: [
          const HomePage(),
          InsightsScreen(
            key: UniqueKey(),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Animate(
        effects: [ScaleEffect(duration: 500.milliseconds), FadeEffect(duration: 500.milliseconds)],
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const AddIncomeExpanse(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                )).then((value) => _homeCubit.getData(selectedMonth));
          },
          child: Image.asset(
            'assets/add.png',
            height: 20,
            width: 20,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 50,
        shadowColor: PrimaryMaterialColor[800],
        // showBlurBottomBar: true,
        // blurOpacity: 0.2,
        // blurFilterX: 5.0,
        // blurFilterY: 10.0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: BlocBuilder<TabCubit, TabState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(45, 10, 45, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _pageController.jumpToPage(0);
                      _tabCubit.changeTab();
                    },
                    child: initialPage == 0
                        ? Animate(
                            child: Animate(
                              effects: [ScaleEffect(duration: 500.milliseconds), FadeEffect(duration: 500.milliseconds)],
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black26, spreadRadius: 1, offset: Offset(0, 2))],
                                    color: Colors.white),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/home_large.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    // Text('Home')
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/home_large.png',
                                height: 30,
                                width: 30,
                              ),
                              // Text('Home')
                            ],
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(1);
                      _tabCubit.changeTab();
                    },
                    child: initialPage == 1
                        ? Animate(
                            effects: [ScaleEffect(duration: 500.milliseconds), FadeEffect(duration: 500.milliseconds)],
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black26, spreadRadius: 1, offset: Offset(0, 2))],
                                  color: Colors.white),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/insights.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  // Text('Insights')
                                ],
                              ),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/insights.png',
                                height: 30,
                                width: 30,
                              ),
                              // Text('Insights')
                            ],
                          ),
                  ),
                ],
              ),
            );
          },
        ),
        // onTap: (value) {
        //   _pageController.jumpToPage(value);
        // },
      ),
    );
  }
}
