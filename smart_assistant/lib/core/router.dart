import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_assistant/core/navigator.dart';
import 'package:smart_assistant/features/chat_bot/view/ChatBot.dart';
import 'package:smart_assistant/features/dashboard/views/home.dart';
import 'package:smart_assistant/features/login/view/LoginPage.dart';
import 'package:smart_assistant/features/qr/views/qrScanner.dart';
import 'package:smart_assistant/features/qr/views/qr.dart';
import 'package:smart_assistant/features/task_list/view/TaskListPage.dart';

// Contains effective routes to navigate between screens
abstract class AppRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      //Routes
      case loginRoute:
        return getPageRoute(
          settings: settings,
          view: const LoginPage(),
        );
      case dashboardRoute:
        return getPageRoute(
          settings: settings,
          view: const Dashboard(),
        );
      case taskListRoute:
        return getPageRoute(
          settings: settings,
          view: const TaskListPage(),
        );
      case qrRoute:
        return getPageRoute(
          settings: settings,
          view: const QrView(),
        );
      case chatBotRoute:
        return getPageRoute(
          settings: settings,
          view: const ChatBot(),
        );
      default:
        return getPageRoute(
          settings: settings,
          view: Scaffold(
            body: Center(
              child: Text("Can't find route ${settings.name}"),
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
