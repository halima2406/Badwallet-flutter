// erreur renvoyee par l'API avec un message clair
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;
}
