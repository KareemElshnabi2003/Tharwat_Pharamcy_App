// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:screen_go/extensions/responsive_nums.dart';
// import 'package:tharwat_pharmacy/Controller/Auth/verify_code_controller.dart';
// import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
// import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/otp_widget.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_click_widget.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

// class VerifyForgetWatsApp extends StatelessWidget {
//   const VerifyForgetWatsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(VerifyCodeController());

//     return Scaffold(
//       backgroundColor: LightMode.whiteColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             appBarPageWidget(true, () {
//               Get.back();
//             }, "Enter OTP Code", LightMode.mainColor, LightMode.mainColor),
//             SizedBox(
//               height: 5.w,
//             ),
//             Image.asset(
//               AppImages.otpImage,
//               width: 70.w,
//               height: 30.h,
//               fit: BoxFit.fill,
//             ),
//             SizedBox(
//               height: 3.w,
//             ),
//             textNormal("We have spent OTP code to your email",
//                 LightMode.blackColor, 3.w, FontWeight.w400),
//             SizedBox(
//               height: 3.w,
//             ),
//             GetBuilder<VerifyCodeController>(
//                 builder: (controller) =>
//                     otpWidget(controller.verifyCodeForgetWatsApp, (val) {
//                       controller.setValForgetPassWats(val);
//                     })),
//             SizedBox(
//               height: 3.w,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 textNormal("Didn't receive the code ?", LightMode.blackColor,
//                     3.5.w, FontWeight.w500),
//                 textClick("Resend OTP", true, () {}, LightMode.mainColor, 4.w),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }