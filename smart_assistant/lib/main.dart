import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'core/navigator.dart';

import 'shared/res/res.dart';
import 'shared/widgets/onboarding_widget.dart';
import 'shared/widgets/page_indicator.dart';
import 'shared/widgets/button.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return OverlaySupport(
            child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Assistant',
          theme: SmartAssistantTheme.lightTheme,
          //darkTheme: .darkTheme,
          home: const MyHomePage(),
          onGenerateRoute: AppRouter.generateRoutes,
          navigatorKey: AppNavigator.key,
        ));
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController? _pageController;
  Timer? _pageAnimationTimer;
  int _page = 0;

  void _animatePages() {
    if (_pageController == null) return;
    if (_page < 2) {
      _pageController?.nextPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageAnimationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _animatePages();
    });
  }

  @override
  void dispose() {
    _pageAnimationTimer?.cancel();
    _pageAnimationTimer = null;
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 9,
              child: PageView(
                controller: _pageController,
                onPageChanged: (newPage) {
                  setState(() {
                    _page = newPage;
                  });
                },
                children: const [
                  OnboardingWidget(
                    image: 'assets/images/FirstStep.gif',
                    title: 'Task Management',
                    subtitle: 'Manage all your tasks in one place',
                  ),
                  OnboardingWidget(
                    image: 'assets/images/SecondStep.gif',
                    title: 'Control',
                    subtitle: 'Control all machine information from one place',
                  ),
                  OnboardingWidget(
                    image: 'assets/images/ThirdStep.gif',
                    title: 'Help',
                    subtitle: 'Get more help from Chat Bot or Human Assistant',
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 4,
                child: Column(
                  children: [
                    SizedBox(height: 64.h),
                    PageIndicatorWidget(
                      count: 3,
                      value: _page,
                      size: 8.w,
                    ),
                    SizedBox(height: 64.h),
                    ButtonPrimary(
                      label: 'Get Started',
                      width: 120.w,
                      height: 50.h,
                      fontSize: 20.sp,
                      onPressed: () =>
                          AppNavigator.pushNamedReplacement(loginRoute),
                    ),
                    SizedBox(height: 42.h),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
