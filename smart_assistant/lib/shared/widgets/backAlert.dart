//create class
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackAlert extends StatefulWidget {
  Widget child;
  BackAlert({Key? key, required this.child}) : super(key: key) {
    child = this.child;
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
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
                child: new Text('Yes'),
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
