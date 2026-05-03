import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:restapi_0029/data/models/user_model.dart';
import 'package:restapi_0029/data/providers/storage_provider.dart';

class AuthRepository {
  final String baseUrl = "https://ternak-be-production.up.railway.app/api/v1";
  final StorageProvider _storage = StorageProvider();

  Future<void> persistToken(String token) async {
    await _storage.saveToken(token);
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }

  Future<void> deleteToken() async {
    await _storage.deleteToken();
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      developer.log('Response Login: ${response.body}', name: 'API');

      if (response.statusCode == 200) {
        await persistToken(data['token']);
        return UserModel.fromJson(data['user']);
      } else {
        throw data['message'] ?? 'Gagal Login';
      }
    } catch (e) {
      developer.log('Error Login: $e', name: 'API');
      rethrow;
    }
  }

  Future<void> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal Registrasi';
    }
  }
}