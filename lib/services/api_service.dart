// lib/core/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/utils/exceptions.dart';

class ApiService {
  static const String _baseUrl = 'https://api.aicareerassistant.com';
  static const Duration _timeout = Duration(seconds: 30);

  final http.Client _client;
  String? _authToken;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client
          .get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
      )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ApiException('Request failed: $e');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client
          .post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ApiException('Request failed: $e');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client
          .put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ApiException('Request failed: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _client
          .delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: _headers,
      )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Network error occurred');
    } catch (e) {
      throw ApiException('Request failed: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    } else {
      switch (response.statusCode) {
        case 400:
          throw BadRequestException('Bad request');
        case 401:
          throw UnauthorizedException('Unauthorized');
        case 403:
          throw ForbiddenException('Forbidden');
        case 404:
          throw NotFoundException('Not found');
        case 422:
          throw ValidationException('Validation error');
        case 500:
          throw ServerException('Internal server error');
        default:
          throw ApiException('Request failed with status: ${response.statusCode}');
      }
    }
  }

  void dispose() {
    _client.close();
  }
}