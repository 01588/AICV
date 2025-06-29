// lib/core/utils/exceptions.dart

// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

// Network related exceptions
class NetworkException extends AppException {
  const NetworkException(String message, [String? code]) : super(message, code);

  @override
  String toString() => 'NetworkException: $message${code != null ? ' (Code: $code)' : ''}';
}

// API related exceptions
class ApiException extends AppException {
  const ApiException(String message, [String? code]) : super(message, code);

  @override
  String toString() => 'ApiException: $message${code != null ? ' (Code: $code)' : ''}';
}

class BadRequestException extends ApiException {
  const BadRequestException(String message) : super(message, '400');
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(String message) : super(message, '401');
}

class ForbiddenException extends ApiException {
  const ForbiddenException(String message) : super(message, '403');
}

class NotFoundException extends ApiException {
  const NotFoundException(String message) : super(message, '404');
}

class ValidationException extends ApiException {
  const ValidationException(String message) : super(message, '422');
}

class ServerException extends ApiException {
  const ServerException(String message) : super(message, '500');
}

// Authentication exceptions
class AuthException extends AppException {
  const AuthException(String message, [String? code]) : super(message, code);

  @override
  String toString() => 'AuthException: $message${code != null ? ' (Code: $code)' : ''}';
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('Invalid email or password');
}

class EmailAlreadyExistsException extends AuthException {
  const EmailAlreadyExistsException() : super('An account with this email already exists');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException() : super('Password is too weak');
}

class EmailNotVerifiedException extends AuthException {
  const EmailNotVerifiedException() : super('Please verify your email address');
}

// Storage exceptions
class StorageException extends AppException {
  const StorageException(String message, [String? code]) : super(message, code);

  @override
  String toString() => 'StorageException: $message${code != null ? ' (Code: $code)' : ''}';
}

class FileNotFoundException extends StorageException {
  const FileNotFoundException(String filename) : super('File not found: $filename');
}

class InsufficientStorageException extends StorageException {
  const InsufficientStorageException() : super('Insufficient storage space');
}

// Cache exceptions
class CacheException extends AppException {
  const CacheException(String message, [String? code]) : super(message, code);

  @override
  String toString() => 'CacheException: $message${code != null ? ' (Code: $code)' : ''}';
}

// Subscription exceptions
class SubscriptionException extends AppException {
  const SubscriptionException(String message, [String? code]) : super(message, code);

  @override
  String toString() => 'SubscriptionException: $message${code != null ? ' (Code: $code)' : ''}';
}

class SubscriptionExpiredException extends SubscriptionException {
  const SubscriptionExpiredException() : super('Your subscription has expired');
}

class FeatureNotAvailableException extends SubscriptionException {
  const FeatureNotAvailableException(String feature)
      : super('Feature not available in your current plan: $feature');
}

// AI Service exceptions
class AIException extends AppException {
  const AIException(String message, [String? code]) : super(message, code);

  @override
  String toString() => 'AIException: $message${code != null ? ' (Code: $code)' : ''}';
}

class AIQuotaExceededException extends AIException {
  const AIQuotaExceededException() : super('AI service quota exceeded');
}

class AIServiceUnavailableException extends AIException {
  const AIServiceUnavailableException() : super('AI service is currently unavailable');
}

// Validation exceptions
class InputValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const InputValidationException(String message, [this.fieldErrors]) : super(message);

  @override
  String toString() => 'InputValidationException: $message${fieldErrors != null ? ' (Fields: $fieldErrors)' : ''}';
}

// File processing exceptions
class FileProcessingException extends AppException {
  const FileProcessingException(String message, [String? code]) : super(message, code);

  @override
  String toString() => 'FileProcessingException: $message${code != null ? ' (Code: $code)' : ''}';
}

class UnsupportedFileFormatException extends FileProcessingException {
  const UnsupportedFileFormatException(String format)
      : super('Unsupported file format: $format');
}

class FileSizeExceededException extends FileProcessingException {
  const FileSizeExceededException(int maxSize)
      : super('File size exceeds maximum allowed size: ${maxSize}MB');
}