import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gomedserv/models/login_model.dart';
import '../utils/gomed_api.dart';

class LoginNotifier extends StateNotifier<UserModel> {
  LoginNotifier() : super(UserModel.initial());

Future<bool> tryAutoLogin() async {
  final prefs = await SharedPreferences.getInstance();

  // Check if the key exists
  if (!prefs.containsKey('userData')) {
    print('No user data found.');
    return false;
  }

  try {
    // Retrieve stored JSON string
    final extractedData = prefs.getString('userData');
    if (extractedData == null) {
      print('User data is null in SharedPreferences.');
      return false;
    }

    // Decode JSON and map it to the UserModel
    final userModel = UserModel.fromJson(json.decode(extractedData));

    // Validate necessary fields
    if (userModel.data != null && userModel.data!.isNotEmpty) {
      final firstData = userModel.data![0];
      if (firstData.accessToken == null || firstData.admin == null) {
        print('Invalid user data structure.');
        return false;
      }

      // Update the state
      state = userModel;
      print('Auto-login successful. User ID: ${state.data?[0].admin?.id}');
      return true;
    } else {
      print('User data structure is empty or invalid.');
      return false;
    }
  } catch (e, stackTrace) {
    print('Error during auto-login: $e');
    print(stackTrace);
    return false;
  }
}






  /// Handles the API call for login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    const String apiUrl = Bbapi.login;
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "password": password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Login successful. Response: ${response.body}");
        final userDetails = json.decode(response.body);
        final user = UserModel.fromJson(userDetails);

        // Save the user model to SharedPreferences
        await prefs.setString('userData', json.encode(user.toJson()));

        // Update the state
        state = user;
        print("Login state updated: ${state.toJson()}");
        return user;
      } else {
        print("Login failed. Status code: ${response.statusCode}");
        throw Exception(
            "Login failed. Status code: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      print("Error during login: $e");
      throw Exception("Login failed. Please check your credentials.");
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, UserModel>((ref) {
  return LoginNotifier();
});
