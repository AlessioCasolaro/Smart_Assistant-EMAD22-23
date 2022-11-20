import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_assistant/core/navigator.dart';
import 'package:smart_assistant/features/login/view/LoginPage.dart';
import 'package:smart_assistant/features/task_list/view/TaskListPage.dart';

// Contains effective routes to navigate between screens
abstract class AppRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      //Routes
      case loginRoute:
        return getPageRoute(
          settings: settings,
          view: LoginPage(),
        );
      case taskListRoute:
        return getPageRoute(
          settings: settings,
          view: TaskListPage(),
        );
      default:
        return getPageRoute(
          settings: settings,
          view: Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static PageRoute<dynamic> getPageRoute({
    required RouteSettings settings,
    required Widget view,
  }) {
    return Platform.isIOS
        ? CupertinoPageRoute(settings: settings, builder: (_) => view)
        : MaterialPageRoute(settings: settings, builder: (_) => view);
  }
}
