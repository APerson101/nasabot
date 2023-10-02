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
            ? const Positioned(
                left: 10, width: 60, bottom: 10, top: 10, child: ChatHistory())
            : Container(),
        Positioned(
            left: isMobile ? 10 : 70,
            right: 0,
            top: 10,
            bottom: 10,
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
    ref.listen(_askingQuestion, (previous, next) {
      if (previous != next) {
        if (next) {
          // ask question
        }
      }
    });
    return Scaffold(
      body: ref.watch(questionHistoryProvider).when(data: (data) {
        return SingleChildScrollView(
          controller: ScrollController()
            ..animateTo(MediaQuery.of(context).size.height * .9,
                duration: const Duration(seconds: 1), curve: Curves.linear),
          child: Column(
              children: data.map((e) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.lightBlue[50]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(child: Text(e)),
                      ))),
            );
          }).toList()),
        );
      }, error: (er, st) {
        debugPrintStack(stackTrace: st);
        return const Center(
          child: Text("Failed to load"),
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }),
      persistentFooterButtons: [
        TextFormField(
          onChanged: (question) {
            ref.watch(_questionProvider.notifier).state = question;
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () async {
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
final _askingQuestion = StateProvider((ref) => false);
