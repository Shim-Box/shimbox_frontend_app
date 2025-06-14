import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DaumPostcodeScreen extends StatefulWidget {
  const DaumPostcodeScreen({super.key});

  @override
  State<DaumPostcodeScreen> createState() => _DaumPostcodeScreenState();
}

class _DaumPostcodeScreenState extends State<DaumPostcodeScreen> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '주소 검색',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri('https://shimbox.web.app/daum_postcode.html'),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;

          controller.addJavaScriptHandler(
            handlerName: 'onSelectAddress',
            callback: (args) {
              final selectedAddress = args[0];
              Navigator.pop(context, selectedAddress);
            },
          );
        },
      ),
    );
  }
}
