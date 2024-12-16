import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:totalizer_cell/services/session_auth.dart';
import 'package:totalizer_cell/views/recibos.dart';

class QRScanner extends StatefulWidget {
  final bool useCompactData; // Variável para definir qual lógica usar
  const QRScanner({super.key, required this.useCompactData});

  @override
  createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final SessionAuth sessionAuth = SessionAuth();

  Future<List<dynamic>> descompactarDados(String conteudoCompactado) async {
    // Decodifica a string para bytes
    List<int> bytesCompactados = base64Decode(conteudoCompactado);
    // Descompacta os bytes usando o GZip
    List<int> dadosBytes = GZipDecoder().decodeBytes(bytesCompactados);
    // Converte os bytes em string
    String dadosString = utf8.decode(dadosBytes);

    return jsonDecode(dadosString);
  }

  // Função para escanear o QrCode (do Arquivo 2)
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        if (widget.useCompactData) {
          // Descompactar dados caso seja a lógica de dados compactados
          descompactarDados(result!.code!).then((dadosDescompactados) {
            // Navegar para Recibos após descompactação
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Recibos(dados: dadosDescompactados),
              ),
            );
          }).catchError((_) {
            // Se não for possível descompactar os dados, volta à tela anterior
            Navigator.pop(context);
          });
        } else {
          // Autentica o código escaneado quando não for compactado
          sessionAuth.authenticateSession(result!.code!, context).then((_) {
            // Após a autenticação bem-sucedida, volta à tela anterior
            Navigator.pop(context);
          });
        }

        controller.pauseCamera();
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.useCompactData
          ? Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('Aponte para um QR code para escanear'),
                  ),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text('Aponte para um QR code para escanear'),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
