import 'dart:async';
import 'dart:io';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'custom_exception.dart';

StatuesRequest handleException(dynamic e) {
  if (e is SocketException) {
    return StatuesRequest.socketException;
  } else if (e is TimeoutException) {
    return StatuesRequest.timeoutException;
  } else if (e is BadRequestException) {
    return StatuesRequest.badRequestException;
  } else if (e is UnauthorizedException) {
    return StatuesRequest.unauthorizedException;
  } else if (e is ForbiddenException) {
    return StatuesRequest.forbiddenException;
  } else if (e is ConflictException) {
    return StatuesRequest.conflictException;
  } else if (e is FormatException) {
    return StatuesRequest.formatException;
  } else {
    return StatuesRequest.unExpectedException;
  }
}
