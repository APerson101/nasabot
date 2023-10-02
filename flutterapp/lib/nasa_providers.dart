import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nasa_providers.g.dart';

String url = "http://3.95.131.62:8000//gethistory";
@riverpod
FutureOr getHistory(GetHistoryRef ref, String id) async {
  var response = await http.post(Uri.parse(url), body: {'username': id});
  debugPrint(response.body);
}

@riverpod
FutureOr askQuestion(AskQuestionRef ref, String id, String question) async {
  var response = await http
      .post(Uri.parse(url), body: {'user_id': id, 'question': question});
  debugPrint(response.body);
}
