import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/chat/presentation/chat_screen.dart';

void main() {
  // السطور دي بتخلي أي خطأ يظهر باللون الأحمر على الشاشة بدل المربع الرمادي
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          'خطأ:\n${details.exceptionAsString()}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  };

  runApp(const ProviderScope(child: MohamedAiApp()));
}

class MohamedAiApp extends StatelessWidget {
  const MohamedAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohamed AI',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG'), Locale('en')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Cairo',
      ),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox(),
      ),
      home: const ChatScreen(),
    );
  }
}
