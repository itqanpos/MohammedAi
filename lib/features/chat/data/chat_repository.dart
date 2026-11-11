import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatRepository {
  // الرابط الجديد بتاعك
  final String supabaseUrl = 'https://zowpjqkkwacfzomfcqxu.supabase.co/functions/v1/super-handler';
  
  // المفتاح بتاعك (اللي بيبدأ بـ sb_publishable_)
  final String supabaseAnonKey = 'sb_publishable_qC70BeNwXBj2nYLxeWriPg_Y_uKJkoh';

  Future<String> getAiResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(supabaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $supabaseAnonKey',
          'apikey': supabaseAnonKey,
        },
        body: jsonEncode({
          'message': message, 
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? 'مفيش رد من السيرفر.';
      } else {
        return 'خطأ في السيرفر (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      return 'مشكلة في الاتصال: $e';
    }
  }
}
