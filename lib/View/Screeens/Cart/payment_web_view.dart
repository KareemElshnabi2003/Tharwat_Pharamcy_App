// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:path/path.dart';
// import 'package:screen_go/extensions/responsive_nums.dart';
// import 'package:tharwat_pharmacy/Controller/Home/Payment/payment_web_view_controller.dart';
// import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';
// import 'package:tharwat_pharmacy/main.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentWebView extends StatefulWidget {
//   final String url;
//   const PaymentWebView({super.key, required this.url});

//   @override
//   State<PaymentWebView> createState() => _WebViewState();
// }

// class _WebViewState extends State<PaymentWebView> {
//   late final WebViewController controller;
//   int loading = 0;
//   @override
//   void initState() {
//     controller = WebViewController()
//       ..loadRequest(
//           Uri.parse(widget.url == "" ? "https://www.google.com/" : widget.url));
//     controller
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageStarted: (url) {
//           setState(() {
//             loading = 0;
//           });
//         },
//         onProgress: (progress) {
//           setState(() {
//             loading = progress;
//           });
//         },
//         onPageFinished: (url) {
//           setState(() {
//             loading = 100;
//           });
//         },
//       ))
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..addJavaScriptChannel(
//         "snakeBar",
//         onMessageReceived: (message) {
//           ScaffoldMessenger.of(context as BuildContext)
//               .showSnackBar(SnackBar(content: Text(message.message)));
//         },
//       );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     PaymentWebViewController paymentController =
//         Get.put(PaymentWebViewController());

//     return PopScope(
//         canPop: false,
//         onPopInvokedWithResult: (didPop, result) {
//           if (didPop) return;
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//           await paymentController.checkStatusofPayment();
//           paymentController.update();
//         });
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: sharedPreferences!.getString("Mood") == "Dark"
//                 ? LightMode.darkMainColor
//                 : LightMode.mainColor,
//             title: textNormal(
//                 "Payment", LightMode.whiteBlueColor, 4.w, FontWeight.w600),
//             leading: IconButton(
//                 onPressed: () async {
//                   await paymentController.checkStatusofPayment();
//                   paymentController.update();
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back_ios,
//                   color: LightMode.whiteBlueColor,
//                 )),
//             actions: [
//               IconButton(
//                   onPressed: () async {
//                     final mesanger = ScaffoldMessenger.of(context);
//                     if (await controller.canGoBack()) {
//                       await controller.goBack();
//                     } else {
//                       mesanger.showSnackBar(const SnackBar(
//                         content: Text("No Back History Found"),
//                         padding: EdgeInsets.all(8),
//                       ));
//                     }
//                     return;
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back_ios,
//                     color: LightMode.whiteBlueColor,
//                   )),
//               IconButton(
//                   onPressed: () async {
//                     final mesanger = ScaffoldMessenger.of(context);
//                     if (await controller.canGoForward()) {
//                       await controller.goForward();
//                     } else {
//                       mesanger.showSnackBar(const SnackBar(
//                           content: Text("No Forward History Found"),
//                           padding: EdgeInsets.all(8)));
//                     }
//                     return;
//                   },
//                   icon: const Icon(
//                     Icons.arrow_forward_ios,
//                     color: LightMode.whiteBlueColor,
//                   )),
//               IconButton(
//                   onPressed: () {
//                     controller.reload();
//                   },
//                   icon: const Icon(
//                     Icons.replay,
//                     color: LightMode.whiteBlueColor,
//                   ))
//             ],
//           ),
//           body: Stack(
//             children: [
//               WebViewWidget(controller: controller),
//               if (loading < 100)
//                 LinearProgressIndicator(
//                   value: loading / 100.0,
//                 )
//             ],
//           ),
//         ));
//   }
// }
