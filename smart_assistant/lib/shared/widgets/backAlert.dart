import 'package:flutter/material.dart';
import 'package:smart_assistant/core/navigator.dart';

class BackAlert extends StatefulWidget {
  Widget child;
  BackAlert({Key? key, required this.child}) : super(key: key) {
    child = child;
  }

  @override
  State<StatefulWidget> createState() {
    return _BackAlertState();
  }
}

class _BackAlertState extends State<BackAlert> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to go back to task list?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, taskListRoute);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop, child: widget.child);
  }
}
