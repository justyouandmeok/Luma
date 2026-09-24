import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeWebPage extends StatefulWidget {
  const YoutubeWebPage({super.key});
  @override
  State<YoutubeWebPage> createState() => _YoutubeWebPageState();
}

class _YoutubeWebPageState extends State<YoutubeWebPage> {
  static const homeUrl = 'https://music.youtube.com';
  late final WebViewController _c;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _c = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0E0E0E))
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => loading = true),
        onPageFinished: (_) => setState(() => loading = false),
      ))
      ..loadRequest(Uri.parse(homeUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Music'),
        actions: [
          IconButton(icon: const Icon(Icons.home_outlined), onPressed: () => _c.loadRequest(Uri.parse(homeUrl))),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => _c.reload()),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () => launchUrl(Uri.parse(homeUrl), mode: LaunchMode.externalApplication),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _c),
          if (loading) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
