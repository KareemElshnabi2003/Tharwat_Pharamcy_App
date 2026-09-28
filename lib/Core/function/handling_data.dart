import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';

/// Centralized parser to extract error message safely from various API response shapes.
String parseErrorMessage(dynamic response,
    {String defaultMessage = "There is a problem. Please, try again later."}) {
  if (response == null) return defaultMessage;
  if (response is String && response.isNotEmpty) return response;

  if (response is Map) {
    // Shape 1: {"error": {"message": "..."}}
    if (response["error"] is Map && response["error"]["message"] != null) {
      return response["error"]["message"].toString();
    }
    // Shape 2: {"error": "..."}
    if (response["error"] is String &&
        (response["error"] as String).isNotEmpty) {
      return response["error"].toString();
    }
    // Shape 3: {"message": "..."}
    if (response["message"] is String &&
        (response["message"] as String).isNotEmpty) {
      return response["message"].toString();
    }
    // Shape 4: {"errors": {"field": ["msg1", "msg2"]}}
    if (response["errors"] is Map) {
      final errorsMap = response["errors"] as Map;
      final firstKey = errorsMap.keys.firstOrNull;
      if (firstKey != null) {
        final val = errorsMap[firstKey];
        if (val is List && val.isNotEmpty) return val.first.toString();
        if (val != null) return val.toString();
      }
    }
  }

  return defaultMessage;
}

StatuesRequest handlingData(dynamic response) {
  if (response is StatuesRequest) {
    return response;
  } else if (response is String) {
    return StatuesRequest.serverError;
  } else if (response is Map || response is List) {
    return StatuesRequest.success;
  } else {
    return StatuesRequest.unExpectedException;
  }
}

// دالة مساعدة لتقليل تكرار الشروط في الـ Controllers
void handleApiResponse({
  required StatuesRequest status,
  required dynamic response,
  required void Function(dynamic data) onSuccess,
}) {
  if (status == StatuesRequest.success) {
    onSuccess(response);
  } else if (status == StatuesRequest.unprocessableException) {
    String errorMsg = parseErrorMessage(response,
        defaultMessage: "Invalid request or data already exists.");
    messageError("Error", errorMsg);
  } else if (status == StatuesRequest.socketException) {
    messageError("Error", "Please check your internet connection.");
  } else if (status == StatuesRequest.unauthorizedException) {
    String errorMsg = parseErrorMessage(response,
        defaultMessage: "Unauthorized access. Please log in again.");
    messageError("Error", errorMsg);
  } else {
    String errorMsg = parseErrorMessage(response,
        defaultMessage: "There is a problem. Please, try again later.");
    messageError("Error", errorMsg);
  }
}
