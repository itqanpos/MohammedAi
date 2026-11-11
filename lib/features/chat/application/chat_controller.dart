import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/chat_message.dart';

class ChatController extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    return [
      ChatMessage(
        text: 'أهلاً بك! أنا محمد AI. كيف يمكنني مساعدتك اليوم؟',
        isUser: false,
        timestamp: DateTime.now(),
      )
    ];
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // 1. إضافة رسالة المستخدم
    state = [
      ...state,
      ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    ];

    // 2. محاكاة رد الذكاء الاصطناعي (مؤقتاً)
    Future.delayed(const Duration(seconds: 2), () {
      state = [
        ...state,
        ChatMessage(
          text: 'هذا رد تجريبي. سيتم ربطي بمحرك الذكاء الاصطناعي قريباً جداً! 🚀',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ];
    });
  }
}

final chatControllerProvider = NotifierProvider<ChatController, List<ChatMessage>>(() {
  return ChatController();
});
