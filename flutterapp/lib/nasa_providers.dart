import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_screen.dart';

part 'nasa_providers.g.dart';

String url = "http://3.95.131.62:8000/request";
String historyur = "http://3.95.131.62:8000/history";
@riverpod
FutureOr getHistory(GetHistoryRef ref, String id) async {
  var response = await http.post(Uri.parse(url), body: {'username': id});
  debugPrint(response.body);
}

@riverpod
FutureOr askQuestion(AskQuestionRef ref, String id, String question) async {
  var response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_id': id, 'question': question}));
  debugPrint(response.body);
}

@riverpod
class QuestionHistory extends _$QuestionHistory {
  @override
  FutureOr<List<String>> build() async {
    return [
      "what is Routh's discriminant?",
      " Routh's discriminant is a measure of dynamical longitudinal stability. According to Bryan's theory, it has been calculated for six speeds ranging from the maximum to the minimum possible speeds for the aeroplane type selected. The value of Routh's discriminant indicates that stability falls off rapidly as speed decreases or angle ofattack increases, and that while this aeroplane appears to be very stable at high speeds, it is frankly unstable at speeds below 47 miles per hour.",
      "What is Bryan's theory?",
      " The purpose of Bryan's theory is to measure the dynamical longitudinal stability of the airplane."
    ];
    // state = AsyncData([...items]);
    // return await getHistory();
  }

  getHistory() async {
    String user = ref.watch(activeuserProvider);
    var response = await http.get(Uri.parse('$historyur/$user'));
    // debugPrint(response.body);
    // var items = json.decode(response.body);
    // debugPrint(items);
    var items = [
      "what is Routh's discriminant?",
      " Routh's discriminant is a measure of dynamical longitudinal stability. According to Bryan's theory, it has been calculated for six speeds ranging from the maximum to the minimum possible speeds for the aeroplane type selected. The value of Routh's discriminant indicates that stability falls off rapidly as speed decreases or angle ofattack increases, and that while this aeroplane appears to be very stable at high speeds, it is frankly unstable at speeds below 47 miles per hour.",
      "What is Bryan's theory?",
      " The purpose of Bryan's theory is to measure the dynamical longitudinal stability of the airplane."
    ];
    state = AsyncData([...items]);
  }

  updateList(String text) async {
    state = AsyncData([...state.value!, text]);
  }

  askQuestion(String id, String question) async {
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_id': id, 'question': question}));
    debugPrint(response.body);

    updateList(jsonDecode(response.body)['answer']);
  }
}
