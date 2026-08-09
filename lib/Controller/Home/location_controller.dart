// // =================================================================
// // 1. CONTROLLER FILE
// // Create: lib/Controller/location_picker_controller.dart
// // =================================================================

// import 'dart:async';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationPickerController extends GetxController {
//   // Observable variables
//   Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
//   RxList<Marker> markers = <Marker>[].obs;

//   // Location data
//   RxString country = ''.obs;
//   RxString street = ''.obs;
//   RxString locality = ''.obs;
//   RxString administrativeArea = ''.obs;
//   RxString subAdministrativeArea = ''.obs;
//   Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);

//   // Manual street input
//   RxString manualStreet = ''.obs;
//   RxBool isStreetManual = false.obs;

//   // Camera position
//   Rx<CameraPosition> cameraPosition = const CameraPosition(
//     target: LatLng(30.9735702, 31.321154),
//     zoom: 14,
//   ).obs;

//   // Loading states
//   RxBool isLoadingLocation = false.obs;
//   RxBool isTrackingLocation = false.obs;

//   StreamSubscription<Position>? positionStream;

//   @override
//   void onInit() {
//     super.onInit();
//     requestLocationPermission();
//   }

//   @override
//   void onClose() {
//     positionStream?.cancel();
//     mapController.value?.dispose();
//     super.onClose();
//   }

//   // Request location permission
//   Future<void> requestLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Get.snackbar(
//         'Error',
//         'Location services are disabled. Please enable them.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Get.snackbar(
//           'Error',
//           'Location permissions are denied',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       Get.snackbar(
//         'Error',
//         'Location permissions are permanently denied',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }

//     // Get current location on init
//     getCurrentLocation();
//   }

//   // Get current location once
//   Future<void> getCurrentLocation() async {
//     try {
//       isLoadingLocation.value = true;
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       LatLng currentLatLng = LatLng(position.latitude, position.longitude);

//       // Move camera to current location
//       if (mapController.value != null) {
//         mapController.value!.animateCamera(
//           CameraUpdate.newLatLng(currentLatLng),
//         );
//       }

//       // Get address for current location
//       await getAddressFromLatLng(currentLatLng);

//       isLoadingLocation.value = false;
//     } catch (e) {
//       isLoadingLocation.value = false;
//       Get.snackbar(
//         'Error',
//         'Failed to get current location: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   // Start tracking location (continuous updates)
//   void startTrackingLocation() {
//     if (isTrackingLocation.value) {
//       stopTrackingLocation();
//       return;
//     }

//     isTrackingLocation.value = true;

//     positionStream = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 10, // Update every 10 meters
//       ),
//     ).listen(
//       (Position position) {
//         LatLng newPosition = LatLng(position.latitude, position.longitude);

//         // Animate camera to new position
//         if (mapController.value != null) {
//           mapController.value!.animateCamera(
//             CameraUpdate.newLatLng(newPosition),
//           );
//         }

//         print('Tracking: ${position.latitude}, ${position.longitude}');
//       },
//       onError: (error) {
//         print('Location tracking error: $error');
//         stopTrackingLocation();
//       },
//     );

//     Get.snackbar(
//       'Tracking Started',
//       'Your location is being tracked',
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 2),
//     );
//   }

//   // Stop tracking location
//   void stopTrackingLocation() {
//     positionStream?.cancel();
//     positionStream = null;
//     isTrackingLocation.value = false;

//     Get.snackbar(
//       'Tracking Stopped',
//       'Location tracking has been stopped',
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 2),
//     );
//   }

//   // Handle map tap
//   Future<void> onMapTapped(LatLng position) async {
//     try {
//       isLoadingLocation.value = true;
//       selectedLocation.value = position;

//       // Clear previous markers and add new one
//       markers.clear();
//       markers.add(
//         Marker(
//           markerId: const MarkerId('selected_location'),
//           position: position,
//           infoWindow: const InfoWindow(title: 'Selected Location'),
//         ),
//       );

//       // Get address for tapped location
//       await getAddressFromLatLng(position);

//       isLoadingLocation.value = false;

//       print('Selected location: ${position.latitude}, ${position.longitude}');
//     } catch (e) {
//       isLoadingLocation.value = false;
//       Get.snackbar(
//         'Error',
//         'Failed to get address: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   // Get address from coordinates
//   Future<void> getAddressFromLatLng(LatLng position) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];

//         country.value = place.country ?? '';

//         // Check if street is a Plus Code (contains + sign) or is empty
//         street.value = '';
//         manualStreet.value = '';
//         String streetValue = place.street ?? '';
//         if (streetValue.isEmpty || streetValue.contains('+')) {
//           // Try to use name or thoroughfare as alternative
//           street.value =
//               place.name ?? place.thoroughfare ?? 'Street name not available';
//         } else {
//           street.value = streetValue;
//         }

//         locality.value = place.locality ?? '';
//         administrativeArea.value = place.administrativeArea ?? '';
//         subAdministrativeArea.value = place.subAdministrativeArea ?? '';

//         print('========================');
//         print('Country: ${country.value}');
//         print('Street: ${street.value}');
//         print('Locality: ${locality.value}');
//         print('Administrative Area: ${administrativeArea.value}');
//         print('Sub Administrative Area: ${subAdministrativeArea.value}');
//         print('========================');
//       }
//     } catch (e) {
//       print('Error getting address: $e');
//       rethrow;
//     }
//   }

//   // Validate if location is selected
//   bool isLocationSelected() {
//     return country.value.isNotEmpty && selectedLocation.value != null;
//   }

//   // Get full address as string
//   String getFullAddress() {
//     List<String> addressParts = [];

//     // Use manual street if provided, otherwise use detected street
//     String streetToUse = isStreetManual.value && manualStreet.value.isNotEmpty
//         ? manualStreet.value
//         : street.value;

//     if (streetToUse.isNotEmpty && !streetToUse.contains('+')) {
//       addressParts.add(streetToUse);
//     }
//     if (locality.value.isNotEmpty) addressParts.add(locality.value);
//     if (subAdministrativeArea.value.isNotEmpty) {
//       addressParts.add(subAdministrativeArea.value);
//     }
//     if (administrativeArea.value.isNotEmpty) {
//       addressParts.add(administrativeArea.value);
//     }
//     if (country.value.isNotEmpty) addressParts.add(country.value);

//     return addressParts.join(', ');
//   }

//   // Get street for display and saving
//   String getStreetForSaving() {
//     return isStreetManual.value && manualStreet.value.isNotEmpty
//         ? manualStreet.value
//         : street.value;
//   }

//   // Reset location data
//   void resetLocation() {
//     markers.clear();
//     country.value = '';
//     street.value = '';
//     locality.value = '';
//     administrativeArea.value = '';
//     subAdministrativeArea.value = '';
//     selectedLocation.value = null;
//   }
// }
