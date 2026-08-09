// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:screen_go/extensions/responsive_nums.dart';
// import 'package:tharwat_pharmacy/Controller/Home/location_controller.dart';
// import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
// import 'package:tharwat_pharmacy/View/Screeens/Cart/check_out_page.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';
// import 'package:tharwat_pharmacy/main.dart';

// class GetInfoLocation extends StatelessWidget {
//   final String payment;
//   final double totalCost;

//   const GetInfoLocation({
//     super.key,
//     required this.payment,
//     required this.totalCost,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Initialize controller
//     final LocationPickerController controller =
//         Get.put(LocationPickerController());

//     return Scaffold(
//       backgroundColor: sharedPreferences!.getString("Mood") == "Dark"
//           ? LightMode.nightColor
//           : LightMode.whiteColor,
//       body: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           // Google Map
//           Obx(() => Container(
//                 color: LightMode.greyColor,
//                 width: 100.w,
//                 height: 100.h,
//                 child: GoogleMap(
//                   onTap: (latlng) => controller.onMapTapped(latlng),
//                   markers: controller.markers.toSet(),
//                   initialCameraPosition: controller.cameraPosition.value,
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: false,
//                   zoomControlsEnabled: false,
//                   onMapCreated: (GoogleMapController mapController) {
//                     controller.mapController.value = mapController;
//                   },
//                 ),
//               )),

//           // Loading Overlay
//           Obx(() => controller.isLoadingLocation.value
//               ? Container(
//                   color: Colors.black26,
//                   child: const Center(
//                     child: CircularProgressIndicator(
//                       color: LightMode.mainColor,
//                     ),
//                   ),
//                 )
//               : const SizedBox.shrink()),

//           // Bottom Info Card
//           Positioned(
//             bottom: 0,
//             right: 2.5.w,
//             left: 2.5.w,
//             child: Obx(() => Container(
//                   padding: EdgeInsets.only(
//                     right: 4.w,
//                     left: 4.w,
//                     top: 4.w,
//                     bottom: 5.w,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(25),
//                       topRight: Radius.circular(25),
//                     ),
//                     color: sharedPreferences!.getString("Mood") == "Dark"
//                         ? LightMode.nightColor
//                         : LightMode.mainColor,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Instruction Text
//                       if (controller.country.value.isEmpty)
//                         Center(
//                           child: textNormal(
//                             "Tap on the map to select your location",
//                             LightMode.whiteColor,
//                             3.5.w,
//                             FontWeight.w500,
//                           ),
//                         ),

//                       // Country
//                       if (controller.country.value.isNotEmpty) ...[
//                         Row(
//                           children: [
//                             textNormal("Country: ", LightMode.whiteColor, 3.5.w,
//                                 FontWeight.w700),
//                             Expanded(
//                               child: textNormal(
//                                 controller.country.value,
//                                 LightMode.orangeColor,
//                                 3.w,
//                                 FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),

//                         // Administrative Area
//                         Row(
//                           children: [
//                             textNormal("Administrative Area: ",
//                                 LightMode.whiteColor, 3.5.w, FontWeight.w700),
//                             Expanded(
//                               child: textNormal(
//                                 controller.administrativeArea.value,
//                                 LightMode.yellowColor,
//                                 3.w,
//                                 FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),

//                         // Sub Administrative Area
//                         Row(
//                           children: [
//                             textNormal("Sub Administrative: ",
//                                 LightMode.whiteColor, 3.5.w, FontWeight.w700),
//                             Expanded(
//                               child: textNormal(
//                                 controller.subAdministrativeArea.value,
//                                 LightMode.yellowColor,
//                                 3.w,
//                                 FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             textNormal("Locality: ", LightMode.whiteColor,
//                                 3.5.w, FontWeight.w700),
//                             Expanded(
//                               child: textNormal(
//                                 controller.locality.value,
//                                 LightMode.yellowColor,
//                                 3.w,
//                                 FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),

//                         // Street
//                         Row(
//                           children: [
//                             textNormal("Street: ", LightMode.whiteColor, 3.5.w,
//                                 FontWeight.w700),
//                             Expanded(
//                               child: controller.street.value.contains('+') ||
//                                       controller.street.value ==
//                                           'Street name not available'
//                                   ? TextField(
//                                       onChanged: (value) {
//                                         controller.manualStreet.value = value;
//                                         controller.isStreetManual.value = true;
//                                       },
//                                       style: TextStyle(
//                                         color: LightMode.yellowColor,
//                                         fontSize: 3.w,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                       decoration: InputDecoration(
//                                         hintText: 'Enter street name',
//                                         hintStyle: TextStyle(
//                                           color: LightMode.yellowColor
//                                               .withOpacity(0.5),
//                                           fontSize: 3.w,
//                                         ),
//                                         border: InputBorder.none,
//                                         isDense: true,
//                                         contentPadding: EdgeInsets.zero,
//                                       ),
//                                     )
//                                   : textNormal(
//                                       controller.street.value,
//                                       LightMode.yellowColor,
//                                       3.w,
//                                       FontWeight.w700,
//                                     ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                       ],

//                       // Confirm Button
//                       buttonWidget(
//                         colorBorder: LightMode.mainColor,
//                         colorFill: controller.isLocationSelected()
//                             ? LightMode.whiteBlueColor
//                             : LightMode.greyColor,
//                         colorText: controller.isLocationSelected()
//                             ? LightMode.mainColor
//                             : LightMode.whiteColor,
//                         margin: false,
//                         onPress: () {
//                           if (controller.isLocationSelected()) {
//                             Get.to(() => const CheckOutPage(), arguments: {
//                               "country": controller.country.value,
//                               "street": controller.getStreetForSaving(),
//                               "admin": controller.administrativeArea.value,
//                               "subAdmin":
//                                   controller.subAdministrativeArea.value,
//                               "locality": controller.locality.value,
//                               "latitude":
//                                   controller.selectedLocation.value!.latitude,
//                               "longitude":
//                                   controller.selectedLocation.value!.longitude,
//                               "fullAddress": controller.getFullAddress(),
//                               "payment": payment,
//                               "totalCost": totalCost,
//                             });
//                           } else {
//                             Get.snackbar(
//                               'No Location Selected',
//                               'Please tap on the map to select your location',
//                               snackPosition: SnackPosition.BOTTOM,
//                             );
//                           }
//                         },
//                         size: 3.w,
//                         text: "Confirm Address",
//                         width: 90.w,
//                       ),
//                     ],
//                   ),
//                 )),
//           ),

//           // Top Header
//           Positioned(
//             top: 0,
//             right: 2.5.w,
//             left: 2.5.w,
//             child: Container(
//               padding: EdgeInsets.only(
//                 right: 5.w,
//                 left: 5.w,
//                 top: 6.h,
//                 bottom: 5.w,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(25),
//                   bottomRight: Radius.circular(25),
//                 ),
//                 color: sharedPreferences!.getString("Mood") == "Dark"
//                     ? LightMode.nightColor
//                     : LightMode.mainColor,
//               ),
//               child: Row(
//                 children: [
//                   // Back Button
//                   InkWell(
//                     onTap: () => Get.back(),
//                     child: SizedBox(
//                       width: 10.w,
//                       child: Icon(
//                         Icons.arrow_back_ios_new,
//                         color: LightMode.whiteColor,
//                         size: 5.w,
//                       ),
//                     ),
//                   ),

//                   // Title
//                   Container(
//                     alignment: Alignment.center,
//                     width: 65.w,
//                     child: textNormal(
//                       "Choose Location",
//                       LightMode.whiteColor,
//                       5.w,
//                       FontWeight.w700,
//                     ),
//                   ),

//                   // Location Tracking Button
//                   SizedBox(
//                     width: 10.w,
//                   )
//                 ],
//               ),
//             ),
//           ),

//           // Current Location FAB
//           Positioned(
//             bottom: 25.h,
//             right: 5.w,
//             child: FloatingActionButton(
//               mini: true,
//               backgroundColor: LightMode.mainColor,
//               onPressed: () => controller.getCurrentLocation(),
//               child: const Icon(
//                 Icons.my_location,
//                 color: LightMode.whiteColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
