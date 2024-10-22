import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'tela_inicio.dart';

class TelaEscanearQrCode extends StatefulWidget {
  @override
  _TelaEscanearQrCodeState createState() => _TelaEscanearQrCodeState();
}

class _TelaEscanearQrCodeState extends State<TelaEscanearQrCode> {
  Future<List<dynamic>>? descompactacao;

  @override
  void initState() {
    super.initState();
    //Escaneamento inicia logo que a tela é aberta
    escanearQrCode();
  }

  //Função para descompactar os dados
  Future<List<dynamic>> descompactarDados(String conteudoCompactado) async{
    return Future((){
    //Decodifica a string pra bytes
    List<int> bytesCompactados = base64Decode(conteudoCompactado);
    //Descompacta os bytes usando o GZip
    List<int> dadosBytes = GZipDecoder().decodeBytes(bytesCompactados);
    //Converte os bytes em string
    String dadosString = utf8.decode(dadosBytes);
    
    return jsonDecode(dadosString);
    });
  }
  //Função para escanear o QrCode
  Future<void> escanearQrCode() async {
    try {
      //Escaneia o QrCode e retorna o resultado
      String conteudoCompactado = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.QR,
      );

      if(conteudoCompactado != '-1'){
        setState(() {
          descompactacao = descompactarDados(conteudoCompactado);
        });
      }
    } catch (e){
      //Exibe um alerta em caso de erro
      if(mounted){
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text('Erro'),
            content: Text('Falha ao escanear o QR code $e'),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('Ok')
              )
            ],
          )
        );
      }
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: descompactacao == null
        ? const CircularProgressIndicator()
        : FutureBuilder(
          future: descompactacao, 
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();     
            }else if(snapshot.hasError){
              return Text('Erro ao descompactar dados: ${snapshot.error}');
            }else{
              List<dynamic> dadosDescompactados = snapshot.data!;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaInicio(dados: dadosDescompactados,)
                  )
                );
              });
              return const SizedBox.shrink();
            }
          }
        )
      ),
    );
  }
}