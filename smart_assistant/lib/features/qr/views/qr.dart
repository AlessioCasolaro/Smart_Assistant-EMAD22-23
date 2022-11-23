import 'package:flutter/material.dart';
import '../qrScanner.dart';

class QrView extends StatelessWidget {
  const QrView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QRScanner(),
    );
  }
}
