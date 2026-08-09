// get post delete  put methode

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/custom_exception.dart';
import 'package:tharwat_pharmacy/Core/function/handle_exception.dart';

class Api {
  Future<Either<StatuesRequest, dynamic>> getData(
      String linkUrl, Map<String, String>? headers) async {
    final url = linkUrl;

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(data);
        return right(data);
      } else if (response.statusCode == 400) {
        throw BadRequestException();
      } else if (response.statusCode == 401) {
        log(response.body);
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        return left(StatuesRequest.serverException);
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else if (response.statusCode == 500) {
        log(response.body);
        return left(StatuesRequest.serverError);
      } else if (response.statusCode == 409) {
        throw ConflictException();
      } else {
        log(response.body);
        return left(StatuesRequest.defaultException);
      }
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

  Future<Either<StatuesRequest, dynamic>> postData(
      String linkUrl, Map<String, String>? headers, Map data) async {
    final url = linkUrl;
    headers ?? {};
    // headers!["Content-Type"] = "application/json";

    final dataPost = jsonEncode(data);
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: dataPost);
      log("${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(data);
        return right(data);
      } else if (response.statusCode == 422) {
        final data = jsonDecode(response.body);
        print(data);
        return left(StatuesRequest.unprocessableException);
      } else if (response.statusCode == 400) {
        log(response.body);
        throw BadRequestException();
      } else if (response.statusCode == 401) {
        log(response.body);
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        log(response.body);
        return left(StatuesRequest.serverException);
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else if (response.statusCode == 500) {
        print(">>>>>  ${response.body}");
        final data = jsonDecode(response.body);
        String message = data['message'];
        print("APi >> $message");
        // return right(message);
        return left(StatuesRequest.serverError);
      } else if (response.statusCode == 409) {
        throw ConflictException();
      } else {
        log("${response.statusCode}");
        return left(StatuesRequest.defaultException);
      }
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

  Future<Either<StatuesRequest, dynamic>> updatePutData(
      String linkUrl, Map<String, String>? headers, Map data) async {
    final url = linkUrl;

    final dataPost = jsonEncode(data);
    try {
      final response =
          await http.put(Uri.parse(url), headers: headers, body: dataPost);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(data);
        return right(data);
      } else if (response.statusCode == 400) {
        throw BadRequestException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        return left(StatuesRequest.serverException);
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else if (response.statusCode == 500) {
        return left(StatuesRequest.serverError);
      } else if (response.statusCode == 409) {
        throw ConflictException();
      } else {
        return left(StatuesRequest.defaultException);
      }
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

  Future<Either<StatuesRequest, dynamic>> updatePatchData(
      String linkUrl, Map<String, String>? headers, Map data) async {
    final url = linkUrl;

    final dataPost = jsonEncode(data);
    try {
      final response =
          await http.patch(Uri.parse(url), headers: headers, body: dataPost);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(data);
        return right(data);
      } else if (response.statusCode == 400) {
        throw BadRequestException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        return left(StatuesRequest.serverException);
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else if (response.statusCode == 500) {
        return left(StatuesRequest.serverError);
      } else if (response.statusCode == 409) {
        throw ConflictException();
      } else {
        return left(StatuesRequest.defaultException);
      }
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

  Future<Either<StatuesRequest, dynamic>> deleteData(
      String linkUrl, Map<String, String>? headers) async {
    final url = linkUrl;

    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(data);
        return right(data);
      } else if (response.statusCode == 400) {
        throw BadRequestException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        return left(StatuesRequest.serverException);
      } else if (response.statusCode == 403) {
        throw ForbiddenException();
      } else if (response.statusCode == 500) {
        return left(StatuesRequest.serverError);
      } else if (response.statusCode == 409) {
        throw ConflictException();
      } else {
        return left(StatuesRequest.defaultException);
      }
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

//post data with file

  Future<Either<StatuesRequest, dynamic>> postRequestwithfile(
      String url, Map data, File? image, String token) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      // Set the Authorization header
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.headers['Lang'] = 'ar';
      request.headers['Accept'] = 'multipart/alternative';

      // Adding a single file (for 'product_image')
      if (image != null) {
        log("img load");
        var stream = http.ByteStream(image.openRead());

        stream.cast();

        request.files
            .add(await http.MultipartFile.fromPath("image", image.path));
      } else {}
      data.forEach((key, value) {
        if (value is List<String>) {
          for (var item in value) {
            request.fields[key] = item;
          }
        } else {
          request.fields[key] =
              value.toString(); // Convert to string to avoid type errors
        }
      });

      var myrequest = await request.send();

      // Send the request

      // Handle the response
      var response = await http.Response.fromStream(myrequest);
      print("???؟؟ $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        return right(
            responseData); // Assuming you have a 'right' function to return success
      } else {
        print("??? ${response.body}");
        switch (response.statusCode) {
          case 400:
            throw BadRequestException();
          case 401:
            throw UnauthorizedException();
          case 403:
            throw ForbiddenException();
          case 404:
            return left(
                StatuesRequest.serverException); // Assuming 'left' is for error
          case 500:
            log(response.body);
            return left(StatuesRequest.serverError);
          case 409:
            throw ConflictException();
          default:
            log(response.body);
            return left(StatuesRequest.defaultException);
        }
      }
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
}
