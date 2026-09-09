import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';

handlingData(response) {
  if (response is StatuesRequest) {
    return response;
  } else if (response is String) {
    return StatuesRequest.serverError;
  } else {
    return StatuesRequest.success;
  }
}

// دالة مساعدة لتقليل تكرار الشروط في الـ Controllers
void handleApiResponse({
  required StatuesRequest status,
  required dynamic response,
  required Function(dynamic data) onSuccess,
}) {
  if (status == StatuesRequest.success) {
    onSuccess(response);
  } else if (status == StatuesRequest.unprocessableException) {
    String errorMsg = response is Map && response["error"] != null
        ? response["error"]["message"]
        : "Invalid request or data already exists.";
    messageError("Error", errorMsg);
  } else if (status == StatuesRequest.socketException) {
    messageError("Error", "Please check your internet connection.");
  } else if (status == StatuesRequest.unauthorizedException) {
    messageError("Error", "Password or email is invalid.");
  } else {
    messageError("Error", "There is a problem. Please, try again later.");
  }
}
