import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:deeplink_listener/deeplink_listener.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<String>? _linkSub;
  String _deeplinkResult = 'Unknown';

  @override
  void initState() {
    super.initState();

    print('[Dart] initState: subscribing to deep link stream');

    // Initial cold start
    DeeplinkListener.getInitialLink().then((link) {
      print('[Dart] getInitialLink: $link');
      if (link != null) _handleDeepLink(link);
    });

    // Stream for incoming links
    DeeplinkListener.linkStream.listen(
      (link) {
        print('[Dart] linkStream received: $link');
        _handleDeepLink(link);
      },
      onError: (err) {
        print('[Dart] linkStream error: $err');
      },
    );
  }

  // Listen for links when app is already running
  void _listenForDeepLinks() {
    _linkSub = DeeplinkListener.linkStream.listen(
      (link) {
        print("Incoming deep link: $link");
        _handleDeepLink(link);
      },
      onError: (err) {
        print("Deep link stream error: $err");
      },
    );
  }

  // Example handler
  void _handleDeepLink(String link) {
    // Do something with the link (e.g., navigation)
    setState(() {
      _deeplinkResult = link;
    });
    print("Handling deep link: $link");
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Running on: $_deeplinkResult\n')),
      ),
    );
  }
}
