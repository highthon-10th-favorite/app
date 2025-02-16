import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserApi {
  final String baseUrl = "${dotenv.env['BASE_URL']}/api/members";
  final String baseUrl2 = "${dotenv.env['BASE_URL2']}";

  User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> getUserById(String uid) async {
    final url = Uri.parse('$baseUrl/$uid');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );

    String decodedResponse = utf8.decode(response.bodyBytes);

    return jsonDecode(decodedResponse) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPictures(String uid) async {
    final url = Uri.parse('$baseUrl2/match-candidates');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'uid': uid}),
    );

    String decodedResponse = utf8.decode(response.bodyBytes);

    return jsonDecode(decodedResponse) as Map<String, dynamic>;
  }
}