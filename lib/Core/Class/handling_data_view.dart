// handling data  by status request to do something
import 'package:flutter/material.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';

class HandlingDataRequest extends StatelessWidget {
  final StatuesRequest statuesRequest;
  final Widget widget;
  const HandlingDataRequest(
      {super.key, required this.statuesRequest, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statuesRequest == StatuesRequest.loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        // : statuesRequest == StatuesRequest.badRequestException
        // ? Container()
        // : statuesRequest == StatuesRequest.conflictException
        // ? Container()
        // : statuesRequest == StatuesRequest.defaultException
        // ? Container()
        // : statuesRequest == StatuesRequest.forbiddenException
        // ? Container()
        // :statuesRequest == StatuesRequest.formatException
        // ?Container()
        // :statuesRequest == StatuesRequest.serverException
        // ?Container()
        : statuesRequest == StatuesRequest.socketException
            ? const Center(
                child: Text("no internet ....."),
              )
            // :statuesRequest == StatuesRequest.unauthorizedException
            // ?Container()
            // :statuesRequest == StatuesRequest.unExpectedException
            // ?Container()
            // :statuesRequest == StatuesRequest.timeoutException
            // ?Container()
            : statuesRequest == StatuesRequest.none
                ? widget
                : widget;
  }
}
