class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;
}
