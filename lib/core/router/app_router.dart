import 'package:go_router/go_router.dart';
import '../../features/chat/presentation/chat_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ChatScreen(),
    ),
  ],
);
