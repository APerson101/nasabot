import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterapp/home_screen.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (newname) {
                ref.watch(activeuserProvider.notifier).state = newname;
              },
              decoration: const InputDecoration(hintText: 'Enter username'),
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Enter password'),
            )),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomeScreen(username: ref.watch(activeuserProvider));
            }));
          },
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60)),
          child: const Text("Login"),
        )
      ]),
    ));
  }
}

final activeuserProvider = StateProvider((ref) => '');
