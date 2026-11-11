import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/chat_message.dart';
import '../data/chat_repository.dart';

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

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. إضافة رسالة المستخدم
    state = [
      ...state,
      ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    ];

    // 2. إضافة رسالة مؤقتة (بيانات انتظار)
    final loadingMessage = ChatMessage(
      text: '... جاري التفكير',
      isUser: false,
      timestamp: DateTime.now(),
    );
    state = [...state, loadingMessage];

    // 3. جلب الرد من Supabase
    final repo = ChatRepository();
    final reply = await repo.getAiResponse(text);

    // 4. مسح رسالة الانتظار وإضافة الرد الحقيقي
    final currentMessages = List<ChatMessage>.from(state);
    currentMessages.removeLast(); // إزالة رسالة "... جاري التفكير"
    currentMessages.add(
      ChatMessage(text: reply, isUser: false, timestamp: DateTime.now()),
    );

    state = currentMessages;
  }
}

final chatControllerProvider = NotifierProvider<ChatController, List<ChatMessage>>(() {
  return ChatController();
});
