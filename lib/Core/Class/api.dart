import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handle_exception.dart';
import 'package:tharwat_pharmacy/main.dart';

class Api {
  static const Duration requestTimeout = Duration(seconds: 30);

  /// Default headers used across all requests.
  static Map<String, String> defaultHeaders({
    String? token,
    bool isJson = false,
  }) {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (sharedPreferences != null) {
      final lang = sharedPreferences!.getString("local");
      headers['Lang'] = (lang == "en") ? "en" : "ar";
    } else {
      headers['Lang'] = 'ar';
    }

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (isJson) {
      headers['Content-Type'] = 'application/json; charset=UTF-8';
    }

    return headers;
  }

  /// Internal helper to merge default headers with caller-provided headers.
  Map<String, String> _buildHeaders(
    Map<String, String>? customHeaders, {
    bool isJson = false,
  }) {
    final headers = defaultHeaders(isJson: isJson);
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  /// Centralized response handler mapping HTTP status codes to StatuesRequest.
  Either<StatuesRequest, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode == 200 || statusCode == 201) {
      try {
        final data = jsonDecode(response.body);
        return right(data);
      } catch (e) {
        return left(StatuesRequest.formatException);
      }
    }

    switch (statusCode) {
      case 400:
        return left(StatuesRequest.badRequestException);
      case 401:
        return left(StatuesRequest.unauthorizedException);
      case 403:
        return left(StatuesRequest.forbiddenException);
      case 404:
        return left(StatuesRequest.serverException);
      case 409:
        return left(StatuesRequest.conflictException);
      case 422:
        return left(StatuesRequest.unprocessableException);
      case 500:
        return left(StatuesRequest.serverError);
      default:
        return left(StatuesRequest.defaultException);
    }
  }

  /// Centralized request execution wrapper with timeout and exception handling.
  Future<Either<StatuesRequest, dynamic>> _executeRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    try {
      final response = await requestFn().timeout(requestTimeout);
      return _handleResponse(response);
    } on SocketException {
      return left(StatuesRequest.socketException);
    } on http.ClientException {
      return left(StatuesRequest.clientException);
    } on TimeoutException {
      return left(StatuesRequest.timeoutException);
    } catch (e) {
      return left(handleException(e));
    }
  }

  Future<Either<StatuesRequest, dynamic>> getData(
    String linkUrl,
    Map<String, String>? headers,
  ) async {
    return _executeRequest(
      () => http.get(
        Uri.parse(linkUrl),
        headers: _buildHeaders(headers),
      ),
    );
  }

  Future<Either<StatuesRequest, dynamic>> postData(
    String linkUrl,
    Map<String, String>? headers,
    Map data,
  ) async {
    final dataPost = jsonEncode(data);
    return _executeRequest(
      () => http.post(
        Uri.parse(linkUrl),
        headers: _buildHeaders(headers, isJson: true),
        body: dataPost,
      ),
    );
  }

  Future<Either<StatuesRequest, dynamic>> updatePutData(
    String linkUrl,
    Map<String, String>? headers,
    Map data,
  ) async {
    final dataPost = jsonEncode(data);
    return _executeRequest(
      () => http.put(
        Uri.parse(linkUrl),
        headers: _buildHeaders(headers, isJson: true),
        body: dataPost,
      ),
    );
  }

  Future<Either<StatuesRequest, dynamic>> updatePatchData(
    String linkUrl,
    Map<String, String>? headers,
    Map data,
  ) async {
    final dataPost = jsonEncode(data);
    return _executeRequest(
      () => http.patch(
        Uri.parse(linkUrl),
        headers: _buildHeaders(headers, isJson: true),
        body: dataPost,
      ),
    );
  }

  Future<Either<StatuesRequest, dynamic>> deleteData(
    String linkUrl,
    Map<String, String>? headers,
  ) async {
    return _executeRequest(
      () => http.delete(
        Uri.parse(linkUrl),
        headers: _buildHeaders(headers),
      ),
    );
  }

  Future<Either<StatuesRequest, dynamic>> postRequestwithfile(
    String url,
    Map data,
    File? image,
    String token,
  ) async {
    return _executeRequest(() async {
      final request = http.MultipartRequest("POST", Uri.parse(url));

      final headers = _buildHeaders({
        'Authorization': 'Bearer $token',
      });
      request.headers.addAll(headers);

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", image.path),
        );
      }

      data.forEach((key, value) {
        if (value is List<String>) {
          for (var item in value) {
            request.fields[key] = item;
          }
        } else {
          request.fields[key] = value.toString();
        }
      });

      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    });
  }
}
