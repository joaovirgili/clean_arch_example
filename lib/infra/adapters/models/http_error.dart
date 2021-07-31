import 'package:equatable/equatable.dart';

class HttpError extends Equatable implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic> data;

  HttpError({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  @override
  String toString() {
    return 'statusCode: $statusCode, message: $message, data: $data';
  }

  @override
  List<Object?> get props => [statusCode, message, data];
}
