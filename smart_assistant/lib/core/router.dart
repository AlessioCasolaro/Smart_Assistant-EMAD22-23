import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:smart_assistant/core/navigator.dart';
import 'package:smart_assistant/features/chat_bot/view/ChatBot.dart';

import 'package:smart_assistant/features/login/view/LoginPage.dart';
import 'package:smart_assistant/features/notification/view/notification.dart';

import 'package:smart_assistant/features/qr/views/qr.dart';
import 'package:smart_assistant/features/task_list/view/TaskListPage.dart';

import 'package:smart_assistant/features/test/test.dart';
import 'package:smart_assistant/features/test/videoTest.dart';

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
      case testRoute:
        return getPageRoute(
          settings: settings,
          view: PorcupineWake(),
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
      case notificationRoute:
        return getPageRoute(
          settings: settings,
          view: const NotificationView(),
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
