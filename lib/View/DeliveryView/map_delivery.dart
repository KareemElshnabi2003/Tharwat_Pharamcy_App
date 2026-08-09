// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:screen_go/extensions/responsive_nums.dart';
// import 'package:tharwat_pharmacy/Controller/Delivery%20View/map_delivery_controller.dart';
// import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
// import 'package:tharwat_pharmacy/View/Widget/HomePage/bottom_sheet_message.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

// class MapDelivery extends StatelessWidget {
//   const MapDelivery({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(MapDeliveryController());
//     return Scaffold(
//       body: GetBuilder<MapDeliveryController>(
//         builder: (controller) => Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Positioned(
//               right: 3.w,
//               left: 3.w,
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: LightMode.mainColor,
//                     borderRadius: BorderRadius.circular(
//                       5.w,
//                     )),
//                 padding: EdgeInsets.only(
//                     right: 5.w, left: 5.w, bottom: 5.w, top: 6.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 15.w,
//                       child: IconButton(
//                           onPressed: () {
//                             bottomSheetMessage(
//                                 body:
//                                     "Are you sure you want to log out from your account ?",
//                                 field: false,
//                                 title: "Log Out",
//                                 context: context,
//                                 onPressNo: () {},
//                                 onPressYes: () {});
//                           },
//                           icon: Icon(
//                             Icons.logout,
//                             size: 6.w,
//                             color: LightMode.redColor,
//                           )),
//                     ),
//                     SizedBox(
//                         width: 50.w,
//                         child: textNormal("Current Location",
//                             LightMode.whiteColor, 5.w, FontWeight.w600)),
//                     SizedBox(
//                       width: 15.w,
//                       child: IconButton(
//                           onPressed: () {},
//                           icon: Icon(
//                             Icons.notifications,
//                             size: 6.w,
//                             color: LightMode.whiteColor,
//                           )),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
