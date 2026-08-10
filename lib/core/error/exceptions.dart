/// Base exception class
class AppException implements Exception {
  final String message;
  final String? code;

  AppException({required this.message, this.code});

  @override
  String toString() => 'AppException: $message';
}

/// Exception for validation errors
class ValidationException extends AppException {
  ValidationException({required super.message, String? code})
      : super(code: code ?? 'VALIDATION_ERROR');
}

/// Exception for not found errors
class NotFoundException extends AppException {
  NotFoundException({required super.message, String? code})
      : super(code: code ?? 'NOT_FOUND');
}

/// Exception for duplicate entries
class DuplicateException extends AppException {
  DuplicateException({required super.message, String? code})
      : super(code: code ?? 'DUPLICATE_ERROR');
}