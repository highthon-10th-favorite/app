import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserApi {
  final String baseUrl = "${dotenv.env['BASE_URL']}/user";
    User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> getUserById(String uid) async {
    final url = Uri.parse('$baseUrl/$uid');
    final idToken = await user?.getIdToken();  
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteUser() async {
    final url = Uri.parse('$baseUrl/${user?.uid}');
    final idToken = await user?.getIdToken();  
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return {'error': 'User not found'};
    }
  }

  Future<http.Response> createUser(String displayName, String profilePicture, String birthDate, String gender) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: ''' '''
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<http.Response> updateUser(String displayName, String birthDate, String gender) async {
    final url = Uri.parse('$baseUrl/${user?.uid}');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: ''' '''
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to update user');
    }
  }
}