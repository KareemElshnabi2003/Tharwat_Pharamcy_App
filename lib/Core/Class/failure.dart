import 'package:tharwat_pharmacy/Core/Class/status_request.dart';

/// Represents a failure outcome from an API or repository call.
/// Retains the status enum for flow control, along with the server-provided
/// error message and raw response body for detailed UI presentation.
class Failure {
  final StatuesRequest status;
  final String? message;
  final dynamic responseBody;

  const Failure({
    required this.status,
    this.message,
    this.responseBody,
  });

  /// Factory helper for creating a Failure with just a status enum.
  factory Failure.fromStatus(StatuesRequest status, [String? message]) {
    return Failure(status: status, message: message);
  }

  @override
  String toString() => message ?? status.name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.status == status;
  }

  @override
  int get hashCode => status.hashCode;
}
