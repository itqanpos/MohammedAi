import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/chat_message.dart';
import '../data/chat_repository.dart';

class ChatController extends Notifier<List<ChatMessage>> {
  final _repo = ChatRepository();
  bool isLoading = false;

  @override
  List<ChatMessage> build() {
    _loadHistory(); // تحميل الرسائل القديمة أول ما التطبيق يفتح
    return [];
  }

  Future<void> _loadHistory() async {
    final history = await _repo.getMessages();
    if (history.isEmpty) {
      state = [
        ChatMessage(text: 'أهلاً بك! أنا محمد AI. اسألني أي حاجة.', isUser: false, timestamp: DateTime.now())
      ];
    } else {
      state = history;
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(text: text, isUser: true, timestamp: DateTime.now());
    
    // 1. إضافة الرسالة للشاشة
    state = [...state, userMsg];
    // 2. حفظها في الداتابيز
    await _repo.saveMessage(userMsg);

    // 3. إظهار مؤشر التحميل
    isLoading = true;
    state = [...state, ChatMessage(text: '...', isUser: false, timestamp: DateTime.now())];

    // 4. جلب الرد
    final replyText = await _repo.getAiResponse(text);
    final aiMsg = ChatMessage(text: replyText, isUser: false, timestamp: DateTime.now());

    // 5. مسح المؤشر وإضافة الرد وحفظه
    state = [
      ...state.sublist(0, state.length - 1),
      aiMsg
    ];
    await _repo.saveMessage(aiMsg);
    isLoading = false;
  }
}

final chatControllerProvider = NotifierProvider<ChatController, List<ChatMessage>>(() {
  return ChatController();
});
