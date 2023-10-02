import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterapp/nasa_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.username});
  final String username;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMobile = MediaQuery.of(context).size.width < 500;
    return Stack(
      children: [
        isMobile
            ? const Positioned(left: 10, width: 60, child: ChatHistory())
            : Container(),
        Positioned(
            left: isMobile ? 10 : 70,
            child: ChatWidget(
              username: username,
            )),
      ],
    );
  }
}

class ChatHistory extends ConsumerWidget {
  const ChatHistory({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Placeholder();
  }
}

class ChatWidget extends ConsumerWidget {
  const ChatWidget({super.key, required this.username});
  final String username;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      persistentFooterButtons: [
        TextFormField(
          onChanged: (question) {
            ref.watch(_questionProvider.notifier).state = question;
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () async {
                    assert(ref.read(_questionProvider) != null);
                    ref.watch(askQuestionProvider(
                        username, ref.watch(_questionProvider)!));
                  },
                  icon: const Icon(Icons.send)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )),
        )
      ],
    );
  }
}

final _questionProvider = StateProvider<String?>((ref) => null);
