import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import 'api_exception.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;
  final Duration timeout;

  ApiClient._()
      : baseUrl = apiBaseUrl,
        _client = http.Client(),
        timeout = const Duration(seconds: 15);

  static final ApiClient instance = ApiClient._();

  Map<String, String> get _headers => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    return _send(() => _client.get(uri, headers: _headers));
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    return _send(
      () => _client.post(uri, headers: _headers, body: jsonEncode(body ?? {})),
    );
  }

  Future<dynamic> _send(Future<http.Response> Function() request) async {
    http.Response res;
    try {
      res = await request().timeout(timeout);
    } on TimeoutException {
      throw ApiException(
        'Le serveur met trop de temps à répondre. Vérifie que le backend est démarré.',
      );
    } catch (_) {
      throw ApiException(
        'Impossible de joindre le serveur ($baseUrl).\n'
        'Vérifie que le backend tourne et que l\'adresse réseau est correcte.',
      );
    }
    return _process(res);
  }

  dynamic _process(http.Response res) {
    dynamic decoded;
    if (res.body.isNotEmpty) {
      try {
        decoded = jsonDecode(utf8.decode(res.bodyBytes));
      } catch (_) {
        decoded = null;
      }
    }

    final ok = res.statusCode >= 200 && res.statusCode < 300;

    if (decoded is Map && decoded.containsKey('success')) {
      if (decoded['success'] == true && ok) {
        return decoded['data'];
      }
      throw ApiException(
        decoded['message']?.toString() ?? 'Une erreur est survenue.',
        statusCode: res.statusCode,
        errors: decoded['errors'],
      );
    }

    if (ok) return decoded;

    throw ApiException(
      (decoded is Map && decoded['message'] != null)
          ? decoded['message'].toString()
          : 'Erreur serveur (${res.statusCode}).',
      statusCode: res.statusCode,
    );
  }

  void dispose() => _client.close();
}
