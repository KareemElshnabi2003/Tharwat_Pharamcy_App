import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tharwat_pharmacy/Core/Class/api.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/Core/function/handling_data.dart';
import 'package:tharwat_pharmacy/Data/Data%20Source/Home/home_source.dart';
import 'package:tharwat_pharmacy/Data/Model/Categories/product_model.dart';
import 'package:tharwat_pharmacy/View/Screeens/Home%20Page/product_info.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/message_error.dart';

class ScanController extends GetxController {
  StatuesRequest statuesRequest = StatuesRequest.none;
  final HomeRemoteData _homeRemoteData = HomeRemoteData(
      Get.isRegistered<Api>() ? Get.find<Api>() : Get.put(Api()));
  ProductModel? productModewl;
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  bool isScanned = false;
  String? scannedCode;

  void onBarcodeDetect(BarcodeCapture barcodes) async {
    if (isScanned) return;
    if (barcodes.barcodes.isEmpty) return;

    final barcode = barcodes.barcodes.first;
    if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
      isScanned = true;

      scannedCode = barcode.rawValue;
      // Show result dialog
      await scan();
      update();
    }
  }

  Future<void> scan() async {
    if (scannedCode == null) return;
    statuesRequest = StatuesRequest.loading;
    update();

    try {
      var response = await _homeRemoteData.scanCode(
        itemCode: scannedCode,
      );

      statuesRequest = handlingData(response);

      if (statuesRequest == StatuesRequest.success && response is Map) {
        final responseBody = response;
        List resList = responseBody['data'] ?? [];
        if (resList.isEmpty) {
          messageError("Result", "This product not available.", back: true,
              onPressBack: () {
            isScanned = false;
            scannedCode = null;

            update();
            Get.back();
          });
        } else {
          productModewl = ProductModel.fromJson(resList[0]);
          Get.to(() => const ProductInfo(), arguments: {
            "id": productModewl!.id.toString(),
            "product": productModewl
          });
          isScanned = false;
          scannedCode = null;
        }
      } else if (statuesRequest == StatuesRequest.socketException) {
        messageError("Error", "please, check your internet");
      } else {
        messageError("Error", "There is a problem. Please, try again later");
      }
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    isScanned = false;
    scannedCode = null;
    super.onInit();
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
