import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerStatefulWidget, ConsumerState;
import 'package:mychatapp/conversations/screens/conversation_screen.dart';
import 'package:mychatapp/provider.dart' show authStateProvider;
import 'package:mychatapp/users/screens/users_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chatly',
          style: GoogleFonts.tangerine(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.purple,
            ),
          ),
        ),
        actions: [
          IconButton(
              //TODO: Implement Error reporting
              onPressed: () =>
                  BetterFeedback.of(context).show((UserFeedback feedback) {}),
              icon: const Icon(Icons.bug_report)),
          IconButton(
              onPressed: () async {
                ref.read(authStateProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: const [
          UsersScreen(),
          ConversationsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() => index = value),
        items: [
          BottomNavigationBarItem(
            icon: Icon(index == 0 ? Icons.person : Icons.person_outline),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(index == 1 ? Icons.message : Icons.message_outlined),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
