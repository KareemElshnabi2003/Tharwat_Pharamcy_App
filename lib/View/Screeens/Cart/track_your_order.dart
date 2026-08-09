// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:screen_go/extensions/responsive_nums.dart';
// import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
// import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';
// import 'package:tharwat_pharmacy/main.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// class TrackYourOrder extends StatefulWidget {
//   const TrackYourOrder({super.key});

//   @override
//   State<TrackYourOrder> createState() => _TrackYourOrderState();
// }

// class _TrackYourOrderState extends State<TrackYourOrder> {
//   final String apiKey = "AIzaSyB1A16IV_dE74r1XEXLcBRG9nk4jUaCKZQ";

//   GoogleMapController? gmc;

//   // Markers
//   Set<Marker> markers = {};

//   // Polylines for route
//   Map<PolylineId, Polyline> polylines = {};

//   // Locations
//   LatLng? userLocation;
//   LatLng? deliveryLocation;

//   // Camera position
//   CameraPosition cameraPosition =
//       const CameraPosition(target: LatLng(30.9735702, 31.321154), zoom: 14);

//   StreamSubscription<Position>? positionStream;

//   // Order data from Get.arguments
//   Map<String, dynamic>? orderData;

//   @override
//   void initState() {
//     super.initState();
//     // Get order data from Get.arguments
//     final arguments = Get.arguments ?? {};
//     // Access the nested 'orderData' object
//     orderData = arguments['orderData'] ?? {};
//     print('Order Data: $orderData'); // Debug print
//     initializeOrderTracking();
//   }

//   @override
//   void dispose() {
//     positionStream?.cancel();
//     super.dispose();
//   }

//   // Initialize order tracking
//   Future<void> initializeOrderTracking() async {
//     // Parse the data from your arguments
//     if (orderData!.containsKey('deliveryLat') &&
//         orderData!.containsKey('deliveryLng')) {
//       deliveryLocation = LatLng(
//         double.parse(orderData!['deliveryLat'].toString()),
//         double.parse(orderData!['deliveryLng'].toString()),
//       );
//       print('Delivery Location: $deliveryLocation'); // Debug print
//     }

//     if (orderData!.containsKey('userLat') &&
//         orderData!.containsKey('userLng')) {
//       userLocation = LatLng(
//         double.parse(orderData!['userLat'].toString()),
//         double.parse(orderData!['userLng'].toString()),
//       );
//       print('User Location: $userLocation'); // Debug print
//     }

//     // If locations are not provided, set defaults
//     deliveryLocation ??= const LatLng(30.9735702, 31.321154);

//     if (userLocation == null) {
//       // Try to get current location
//       try {
//         Position position = await getCurrentLocation();
//         userLocation = LatLng(position.latitude, position.longitude);
//       } catch (e) {
//         print('Error getting current location: $e');
//         // Set default user location
//         userLocation = const LatLng(22.9735702, 30.321154);
//       }
//     }

//     // Add markers
//     addMarkers();

//     // Draw route
//     await drawRoute();

//     // Move camera to show both markers
//     Future.delayed(const Duration(milliseconds: 500), () {
//       moveCameraToShowRoute();
//     });
//   }

//   // Get current location
//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied');
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   // Add markers for user and delivery
//   void addMarkers() {
//     markers.clear(); // Clear existing markers

//     if (userLocation != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId('user'),
//           position: userLocation!,
//           infoWindow: const InfoWindow(
//             title: 'Your Location',
//             snippet: 'Order destination',
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         ),
//       );
//       print('User marker added at: $userLocation');
//     }

//     if (deliveryLocation != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId('delivery'),
//           position: deliveryLocation!,
//           infoWindow: const InfoWindow(
//             title: 'Delivery Person',
//             snippet: 'Current location',
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       );
//       print('Delivery marker added at: $deliveryLocation');
//     }

//     setState(() {});
//   }

//   // Draw route between user and delivery
//   Future<void> drawRoute() async {
//     if (userLocation == null || deliveryLocation == null) {
//       print('Cannot draw route - locations are null');
//       return;
//     }

//     print('Drawing route from $deliveryLocation to $userLocation');

//     try {
//       PolylinePoints polylinePoints = PolylinePoints(apiKey: apiKey);

//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         request: PolylineRequest(
//           origin: PointLatLng(
//               deliveryLocation!.latitude, deliveryLocation!.longitude),
//           destination:
//               PointLatLng(userLocation!.latitude, userLocation!.longitude),
//           mode: TravelMode.driving,
//         ),
//       );

//       if (result.points.isNotEmpty) {
//         print('Route found with ${result.points.length} points');

//         List<LatLng> polylineCoordinates = result.points
//             .map((point) => LatLng(point.latitude, point.longitude))
//             .toList();

//         PolylineId id = const PolylineId('route');
//         Polyline polyline = Polyline(
//           polylineId: id,
//           color: LightMode.orangeColor,
//           points: polylineCoordinates,
//           width: 5,
//           patterns: [PatternItem.dash(30), PatternItem.gap(20)],
//         );

//         setState(() {
//           polylines[id] = polyline;
//         });
//         print('Polyline drawn successfully');
//       } else {
//         print('No route points found. Error: ${result.errorMessage}');
//         // Draw a straight line as fallback
//         drawStraightLine();
//       }
//     } catch (e) {
//       print('Error drawing route: $e');
//       // Draw a straight line as fallback
//       drawStraightLine();
//     }
//   }

//   // Draw a straight line if route API fails
//   void drawStraightLine() {
//     if (userLocation == null || deliveryLocation == null) return;

//     PolylineId id = const PolylineId('route');
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: LightMode.orangeColor,
//       points: [deliveryLocation!, userLocation!],
//       width: 5,
//       patterns: [PatternItem.dash(30), PatternItem.gap(10)],
//     );

//     setState(() {
//       polylines[id] = polyline;
//     });
//     print('Straight line drawn as fallback');
//   }

//   // Move camera to show both markers
//   void moveCameraToShowRoute() {
//     if (userLocation == null || deliveryLocation == null || gmc == null) {
//       print('Cannot move camera - locations or controller null');
//       return;
//     }

//     // Calculate bounds
//     double southLat = userLocation!.latitude < deliveryLocation!.latitude
//         ? userLocation!.latitude
//         : deliveryLocation!.latitude;
//     double northLat = userLocation!.latitude > deliveryLocation!.latitude
//         ? userLocation!.latitude
//         : deliveryLocation!.latitude;
//     double westLng = userLocation!.longitude < deliveryLocation!.longitude
//         ? userLocation!.longitude
//         : deliveryLocation!.longitude;
//     double eastLng = userLocation!.longitude > deliveryLocation!.longitude
//         ? userLocation!.longitude
//         : deliveryLocation!.longitude;

//     LatLngBounds bounds = LatLngBounds(
//       southwest: LatLng(southLat, westLng),
//       northeast: LatLng(northLat, eastLng),
//     );

//     gmc!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
//     print('Camera moved to show both locations');
//   }

//   // Calculate distance between user and delivery
//   String getDistance() {
//     if (userLocation == null || deliveryLocation == null) {
//       return "Calculating...";
//     }

//     double distanceInMeters = Geolocator.distanceBetween(
//       userLocation!.latitude,
//       userLocation!.longitude,
//       deliveryLocation!.latitude,
//       deliveryLocation!.longitude,
//     );

//     if (distanceInMeters < 1000) {
//       return "${distanceInMeters.toStringAsFixed(0)} m";
//     } else {
//       return "${(distanceInMeters / 1000).toStringAsFixed(1)} km";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: sharedPreferences!.getString("Mood") == "Dark"
//           ? LightMode.nightColor
//           : LightMode.whiteColor,
//       body: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           // Google Map
//           Container(
//             color: LightMode.greyColor,
//             width: 100.w,
//             height: 100.h,
//             child: GoogleMap(
//               markers: markers,
//               polylines: Set<Polyline>.of(polylines.values),
//               initialCameraPosition: cameraPosition,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//               zoomControlsEnabled: false,
//               mapType: MapType.normal,
//               onMapCreated: (controller) {
//                 gmc = controller;
//                 print('Map created');
//                 // Small delay to ensure map is ready
//                 Future.delayed(const Duration(milliseconds: 500), () {
//                   moveCameraToShowRoute();
//                 });
//               },
//             ),
//           ),

//           // Bottom info card
//           Positioned(
//             bottom: 0,
//             right: 2.5.w,
//             left: 2.5.w,
//             child: Container(
//               padding: EdgeInsets.only(
//                 right: 4.w,
//                 left: 4.w,
//                 top: 4.w,
//                 bottom: 5.w,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(25),
//                   topRight: Radius.circular(25),
//                 ),
//                 color: sharedPreferences!.getString("Mood") == "Dark"
//                     ? LightMode.nightColor
//                     : LightMode.mainColor,
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           textNormal("Order ID:", LightMode.whiteColor, 3.5.w,
//                               FontWeight.w700),
//                           textNormal(
//                             " #${orderData?['orderId'] ?? '123456789'}",
//                             LightMode.orangeColor,
//                             3.w,
//                             FontWeight.w700,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           textNormal("Status:", LightMode.whiteColor, 3.5.w,
//                               FontWeight.w700),
//                           textNormal(
//                             " ${orderData?['status'] ?? 'on way'}",
//                             LightMode.yellowColor,
//                             3.w,
//                             FontWeight.w700,
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on,
//                             color: LightMode.whiteColor,
//                             size: 4.w,
//                           ),
//                           SizedBox(width: 1.w),
//                           textNormal(
//                             getDistance(),
//                             LightMode.whiteColor,
//                             3.w,
//                             FontWeight.w700,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   buttonWidget(
//                     colorBorder: LightMode.mainColor,
//                     colorFill: LightMode.whiteBlueColor,
//                     colorText: LightMode.mainColor,
//                     margin: false,
//                     onPress: () {
//                       // Get.to(() => const OrderDetails(),
//                       //     arguments: {"orderModel": orderData});
//                     },
//                     size: 3.w,
//                     text: "Order Details",
//                     width: 90.w,
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Top header
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
//                   InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: SizedBox(
//                       width: 10.w,
//                       child: Icon(
//                         Icons.arrow_back_ios_new,
//                         color: LightMode.whiteColor,
//                         size: 5.w,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     width: 65.w,
//                     child: textNormal(
//                       "Track your order",
//                       LightMode.whiteColor,
//                       5.w,
//                       FontWeight.w700,
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                 ],
//               ),
//             ),
//           ),

//           // Refresh button
//           Positioned(
//             top: 15.h,
//             right: 5.w,
//             child: FloatingActionButton(
//               mini: true,
//               backgroundColor: LightMode.mainColor,
//               onPressed: () {
//                 print('Refresh button pressed');
//                 drawRoute();
//                 moveCameraToShowRoute();
//               },
//               child: const Icon(
//                 Icons.refresh,
//                 color: LightMode.whiteColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
