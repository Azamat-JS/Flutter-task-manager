import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (res.statusCode != 201) {
        throw jsonDecode(res.body);
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      final body = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode != 200) {
        throw body['message'] ?? 'Login failed';
      }

      return UserModel.fromMap({
        ...body['user'] as Map<String, dynamic>,
        'token': body['accessToken'],
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
