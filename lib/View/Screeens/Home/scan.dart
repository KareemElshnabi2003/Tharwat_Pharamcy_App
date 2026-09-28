import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/scan_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class MedicineScannerScreen extends StatelessWidget {
  const MedicineScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          homeController.changePage(0);
          homeController.choose_1 = true;
          homeController.choose_3 = false;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GetBuilder<ScanController>(
          init: Get.isRegistered<ScanController>() ? null : ScanController(),
          builder: (controller) => controller.statuesRequest ==
                  StatuesRequest.loading
              ? Center(
                  child: TextNormalWidget(
                      text: "Searching...",
                      color: LightMode.whiteColor,
                      size: 5.w,
                      weight: FontWeight.w600))
              : Stack(
                  children: [
                    MobileScanner(
                        controller: controller.cameraController,
                        onDetect: controller.onBarcodeDetect),
                    CustomPaint(painter: ScannerOverlay(), child: Container()),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 5.w, right: 5.w, top: 6.h, bottom: 3.w),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.transparent
                            ])),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(Icons.arrow_back_ios_new,
                                    color: Colors.white, size: 6.w),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            TextNormalWidget(
                                text: "Scan Medicine Barcode",
                                color: Colors.white,
                                size: 5.w,
                                weight: FontWeight.w700),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.transparent
                            ])),
                        child: Column(
                          children: [
                            Icon(Icons.qr_code_scanner,
                                color: Colors.white, size: 12.w),
                            SizedBox(height: 2.h),
                            TextNormalWidget(
                                text: "Position the barcode within the frame",
                                color: Colors.white,
                                size: 3.5.w,
                                weight: FontWeight.w500),
                            SizedBox(height: 1.h),
                            TextNormalWidget(
                                text:
                                    "The scanner will automatically detect the code",
                                color: Colors.white70,
                                size: 3.w,
                                weight: FontWeight.w400),
                            SizedBox(height: 3.h),
                            InkWell(
                              onTap: () =>
                                  controller.cameraController.toggleTorch(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 3.w),
                                decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.flash_on,
                                        color: Colors.white, size: 6.w),
                                    SizedBox(width: 2.w),
                                    TextNormalWidget(
                                        text: "Toggle Flash",
                                        color: Colors.white,
                                        size: 3.5.w,
                                        weight: FontWeight.w600),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaSize = size.width * 0.7;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final scanAreaPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize),
          const Radius.circular(20)));
    final path =
        Path.combine(PathOperation.difference, backgroundPath, scanAreaPath);
    canvas.drawPath(path, backgroundPaint);
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    const cornerLength = 30.0;
    canvas.drawLine(
        Offset(left, top + cornerLength), Offset(left, top), borderPaint);
    canvas.drawLine(
        Offset(left, top), Offset(left + cornerLength, top), borderPaint);
    canvas.drawLine(Offset(left + scanAreaSize - cornerLength, top),
        Offset(left + scanAreaSize, top), borderPaint);
    canvas.drawLine(Offset(left + scanAreaSize, top),
        Offset(left + scanAreaSize, top + cornerLength), borderPaint);
    canvas.drawLine(Offset(left, top + scanAreaSize - cornerLength),
        Offset(left, top + scanAreaSize), borderPaint);
    canvas.drawLine(Offset(left, top + scanAreaSize),
        Offset(left + cornerLength, top + scanAreaSize), borderPaint);
    canvas.drawLine(
        Offset(left + scanAreaSize - cornerLength, top + scanAreaSize),
        Offset(left + scanAreaSize, top + scanAreaSize),
        borderPaint);
    canvas.drawLine(
        Offset(left + scanAreaSize, top + scanAreaSize - cornerLength),
        Offset(left + scanAreaSize, top + scanAreaSize),
        borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
