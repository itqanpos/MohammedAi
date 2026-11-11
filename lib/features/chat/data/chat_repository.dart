import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/chat_message.dart';

class ChatRepository {
  final _supabase = Supabase.instance.client;
  
  final String supabaseUrl = 'https://zowpjqkkwacfzomfcqxu.supabase.co/functions/v1/super-handler';
  final String supabaseAnonKey = 'sb_publishable_qC70BeNwXBj2nYLxeWriPg_Y_uKJkoh';

  // 1. جلب الرسائل الخاصة بالمستخدم الحالي فقط
  Future<List<ChatMessage>> getMessages() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('messages')
          .select()
          .eq('user_id', userId) // الفلترة هنا
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

  // 2. حفظ الرسالة وربطها بالمستخدم
  Future<void> saveMessage(ChatMessage msg) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase.from('messages').insert({
        'content': msg.text,
        'is_user': msg.isUser,
        'user_id': userId, // ربط الرسالة بالمستخدم
      });
    } catch (e) {
      // تجاهل الخطأ
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
        return 'خطأ (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      return 'مشكلة في الاتصال بالإنترنت.';
    }
  }
}
