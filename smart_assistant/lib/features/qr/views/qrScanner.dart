import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_assistant/features/dashboard/views/home.dart';
import 'package:smart_assistant/features/task_list/classes/Response.dart';
import 'package:smart_assistant/shared/widgets/button.dart';
import 'dart:developer';
import 'dart:io';
import '../../../core/navigator.dart';
import '../../../shared/widgets/backAlert.dart';

class QRScanner extends StatefulWidget {
  String codiceUtente = "";
  String codiceIstanzaAttivita = "";
  AttivitaAttivitas? attivita;
  OggettoOggetto? oggetto;

  QRScanner(
      {Key? key,
      required String codUtente,
      required String codIstanzaAttivita,
      required AttivitaAttivitas selectedAttivita})
      : super(key: key) {
    codiceUtente = codUtente;
    attivita = selectedAttivita;
  }

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    log("Codice utente QR" + widget.codiceUtente);
    log("QR" +
        widget.attivita!.codiceAttivita +
        widget.attivita!.oggettoOggettos[0].codiceOggetto);
    widget.oggetto = widget.attivita!.oggettoOggettos[0];
    String qrInput = '';
    if (widget.oggetto!.nome.length <= 21) {
      qrInput = widget.oggetto!.nome;
    } else {
      if(widget.oggetto!.nome.substring(20, 21) == ' ') {
        qrInput = widget.oggetto!.nome.substring(0, 20)  + '...';
      } else {
        qrInput = widget.oggetto!.nome.substring(0, 21)  + '...';
      }
    }
    return BackAlert(
      codUtente: widget.codiceUtente,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                      'Machine code scanned: ${result!.code}',
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    )
                  else
                    Text("Scan $qrInput's QR code",
                        style: TextStyle(
                          fontSize: 28.sp,
                        )),
                  if (result != null && result!.code == widget.oggetto!.nome)
                    SizedBox(
                      width: 100.w,
                      child: ButtonPrimary(
                        label: 'Start Task',
                        width: 100.w,
                        height: 55.h,
                        fontSize: 20.sp,
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboard(
                                codUtente: widget.codiceUtente,
                                codAttivita: widget.attivita!.codiceAttivita,
                                codOggetto: widget.oggetto!.codiceOggetto,
                                codIstanzaAttivita:
                                    widget.codiceIstanzaAttivita,
                                startedAttivita:
                                    widget.attivita!.codiceAttivita,
                                selectedOggetto: widget
                                    .attivita!.oggettoOggettos[0].codiceOggetto,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else if (result == null)
                    SizedBox()
                  else
                    Text('QR not correct. Retry!',
                        style: TextStyle(color: Colors.red, fontSize: 22.sp)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ButtonIconNoBG(
                        label: "Flash",
                        icon: Icons.flash_on,
                        onPressed: () async {
                          await controller!.toggleFlash();
                          setState(() {});
                        },
                        height: 55.h,
                        width: 100.w,
                        fontSize: 28.sp,
                        iconSize: 30.sp,
                      ),
                      ButtonIconNoBG(
                        label: "Flip",
                        icon: Icons.flip_camera_android,
                        onPressed: () async {
                          await controller?.flipCamera();
                          setState(() {});
                        },
                        height: 55.h,
                        width: 100.w,
                        fontSize: 28.sp,
                        iconSize: 30.sp,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
