import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/chat_message.dart';

class ChatRepository {
  final _supabase = Supabase.instance.client;
  
  final String supabaseUrl = 'https://zowpjqkkwacfzomfcqxu.supabase.co/functions/v1/super-handler';
  final String supabaseAnonKey = 'sb_publishable_qC70BeNwXBj2nYLxeWriPg_Y_uKJkoh';

  // 1. جلب الرسائل القديمة من الداتابيز
  Future<List<ChatMessage>> getMessages() async {
    try {
      final response = await _supabase
          .from('messages')
          .select()
          .order('created_at', ascending: true);

      return (response as List).map((json) => ChatMessage(
        text: json['content'],
        isUser: json['is_user'],
        timestamp: DateTime.parse(json['created_at']),
      )).toList();
    } catch (e) {
      return [];
    }
  }

  // 2. حفظ الرسالة في الداتابيز
  Future<void> saveMessage(ChatMessage msg) async {
    try {
      await _supabase.from('messages').insert({
        'content': msg.text,
        'is_user': msg.isUser,
      });
    } catch (e) {
      // تجاهل الخطأ مؤقتاً لو النت فصل
    }
  }

  // 3. جلب الرد من الذكاء الاصطناعي
  Future<String> getAiResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(supabaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $supabaseAnonKey',
          'apikey': supabaseAnonKey,
        },
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? 'مفيش رد.';
      } else {
        return 'المساعد مشغول حالياً، جرب تاني.';
      }
    } catch (e) {
      return 'مشكلة في الاتصال بالإنترنت.';
    }
  }
}
