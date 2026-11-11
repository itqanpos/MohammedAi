import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/chat/presentation/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // بنحاول نتصل بـ Supabase، بس بحد أقصى 10 ثواني
    await Supabase.initialize(
      url: 'https://zowpjqkkwacfzomfcqxu.supabase.co',
      anonKey: 'sb_publishable_qC70BeNwXBj2nYLxeWriPg_Y_uKJkoh',
    ).timeout(const Duration(seconds: 10));

    final auth = Supabase.instance.client.auth;
    if (auth.currentSession == null) {
      // تسجيل دخول تلقائي بحد أقصى 10 ثواني
      await auth.signInAnonymously().timeout(const Duration(seconds: 10));
    }
  } catch (e) {
    // لو حصل خطأ، بنطبعه في الكونسول وبنكمل عشان التطبيق يفتح
    debugPrint('Supabase Error: $e');
  }

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00897B),
          brightness: Brightness.light,
        ),
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
