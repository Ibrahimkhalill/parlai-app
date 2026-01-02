import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:parlai/wdiget/apiClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final ApiClient apiClient = ApiClient();

  // -----------------------
  // Signup
  // -----------------------
  Future<int> signUp({
    required String email,
    required String password,
    required String name,
    String role = 'user',
    String? phoneNumber,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/sign-up',
        data: {
          'email_address': email,
          'password': password,
          'name': name,
          'role': role,
        },
      );

      // Backend sends: { message: "...", user_id: 123 }
      print(response.data['message']); // OTP sent successfully

      // Return user_id for OTP verification
      return response.data['user_id'];
    } catch (e) {
      print(e);
      throw _handleError(e);
    }
  }

  Future<void> verifyOtp({required int userId, required String code}) async {
    try {
      final response = await apiClient.post(
        '/auth/verify-email',
        data: {'user_id': userId, 'verification_code': code},
      );

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('access_token', response.data['access_token']);
      await prefs.setString('refresh_token', response.data['refresh_token']);
      await prefs.setString('email_address', response.data['email_address']);
      await prefs.setString('role', response.data['role']);
      await prefs.setBool('is_verified', response.data['is_verified']);
      await prefs.setString('profile', response.data['profile'].toString());
      await prefs.setInt(
        'access_token_valid_till',
        response.data['access_token_valid_till'],
      );

      print('OTP Verified and user data saved locally.');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> resendVerificationCode({
    required int userId,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/resend-verification-code',
        data: {'user_id': userId},
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // -----------------------
  // Login
  // -----------------------
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await apiClient.post(
        '/auth/sign-in',
        data: {'email_address': email, 'password': password},
      );

      final data = response.data;
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('access_token', data['access_token']);
      await prefs.setString('refresh_token', data['refresh_token']);
      await prefs.setString('email_address', data['email_address']);
      await prefs.setString('role', data['role']);
      await prefs.setBool('is_verified', data['is_verified']);
      await prefs.setString('profile', data['profile'].toString());
      await prefs.setInt(
        'access_token_valid_till',
        data['access_token_valid_till'],
      );

      // 🔥 MUST
      await apiClient.setToken(data['access_token']);

      print("LOGIN TOKEN SAVED: ${data['access_token']}");
    } catch (e) {
      throw _handleError(e);
    }
  }

  // -----------------------
  // Get User Profile
  // -----------------------
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await apiClient.get('/auth/profile');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // -----------------------
  // Update Profile
  // -----------------------
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.put('/auth/profile/update', data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateProfilePicture({
    File? file, // optional, user may update only name
  }) async {
    try {
      FormData formData = FormData();
      // Add profile picture if provided
      if (file != null) {
        formData.files.add(
          MapEntry(
            'profile_picture',
            await MultipartFile.fromFile(file.path, filename: 'profile.jpg'),
          ),
        );
      }

      // Send PUT request with FormData
      final response = await apiClient.put(
        '/auth/profile/update',
        data: formData,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // -----------------------
  // Forgot Password
  // -----------------------
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await apiClient.post(
        '/auth/forgot-password',
        data: {'email_address': email},
      );
      return response.data;
    } catch (e) {
      print(e);
      throw _handleError(e);
    }
  }

  // -----------------------
  // Verify Reset Code
  // -----------------------
  Future<Map<String, dynamic>> verifyResetCode({
    required int userId,
    required String code,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/verify-reset-code',
        data: {'user_id': userId, 'verification_code': code},
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // -----------------------
  // Reset Password
  // -----------------------
  Future<Map<String, dynamic>> resetPassword({
    required int userId,
    required String password,
    required String secret_key,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/reset-password',
        data: {
          'user_id': userId,
          'new_password': password,
          'secret_key': secret_key,
        },
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // -----------------------
  // Change Password
  // -----------------------
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/change-password',
        data: {'old_password': oldPassword, 'new_password': newPassword},
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // -----------------------
  // Error Handling
  // -----------------------
  Exception _handleError(dynamic e) {
    if (e is DioException) {
      // ✅ Always trust DioException.message
      return Exception(e.message ?? "Something went wrong");
    }

    return Exception(e.toString());
  }
}

// Global instance
final authController = AuthController();
