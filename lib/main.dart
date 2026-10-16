import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const TorahApp());

class TorahApp extends StatelessWidget {
  const TorahApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Jumash por Parashá',
        debugShowCheckedModeBanner: false,
        home: TorahPage(),
      );
}

class TorahPage extends StatefulWidget {
  const TorahPage({super.key});
  @override
  State<TorahPage> createState() => _TorahPageState();
}

class _TorahPageState extends State<TorahPage> {
  late final WebViewController _c;
  @override
  void initState() {
    super.initState();
    _c = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF3F5F8))
      ..loadFlutterAsset('assets/index.html');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        // El botón atrás vuelve a la lista de parashot; si ya está ahí, cierra la app.
        final atHome = await _c.runJavaScriptReturningResult(
            'document.getElementById("backBtn").hidden');
        if (atHome.toString() == 'true') {
          SystemNavigator.pop();
        } else {
          _c.runJavaScript('document.getElementById("backBtn").click()');
        }
      },
      child: Scaffold(body: SafeArea(child: WebViewWidget(controller: _c))),
    );
  }
}
