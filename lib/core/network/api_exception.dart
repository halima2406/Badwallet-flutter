/// Exception métier/réseau remontée par [ApiClient] avec un message lisible
/// pour l'utilisateur.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;
}
