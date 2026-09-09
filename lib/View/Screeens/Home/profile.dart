import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Profile/profile_controller.dart';
import 'package:tharwat_pharmacy/Controller/Home/home_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Screeens/Profile/change_password.dart';
import 'package:tharwat_pharmacy/View/Screeens/Profile/about_us.dart';
import 'package:tharwat_pharmacy/View/Screeens/Profile/contact_us.dart';
import 'package:tharwat_pharmacy/View/Screeens/Profile/delete_account.dart';
import 'package:tharwat_pharmacy/View/Screeens/Profile/my_orders.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/bottom_sheet_message.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';
import 'package:tharwat_pharmacy/main.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    HomeController homeController = Get.put(HomeController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
        homeController.changePage(0);
        homeController.choose_1 = true;
        homeController.choose_2 = false;
      });
        },
      child: Scaffold(
        backgroundColor: ThemeService.backgroundColor,
        body: GetBuilder<ProfileController>(
          builder: (controller) => controller.statuesRequest ==
                  StatuesRequest.loading
              ? LoadingWidget(height: 80.h)
              : Container(
                  margin: EdgeInsets.only(bottom: 5.h),
                  height: 100.h,
                  width: 100.w,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 30.h,
                        width: 96.w,
                        margin: EdgeInsets.only(right: 2.w, left: 2.w),
                        decoration: BoxDecoration(
                          color: ThemeService.primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(7.w),
                              bottomLeft: Radius.circular(7.w)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: sharedPreferences!
                                          .getString("image") ==
                                      "null"
                                  ? AssetImage(AppImages.noImage)
                                      as ImageProvider
                                  : CachedNetworkImageProvider(
                                      "${AppApi.imgUrl}/${sharedPreferences!.getString("image")}"),
                              radius: 7.w,
                            ),
                            const SizedBox(height: 10),
                            TextNormalWidget(
                                text:
                                    sharedPreferences!.getString("name") ?? "",
                                color: LightMode.whiteColor,
                                size: 4.w,
                                weight: FontWeight.w700),
                            TextNormalWidget(
                                text:
                                    sharedPreferences!.getString("email") ?? "",
                                color: ThemeService.isDark
                                    ? LightMode.whiteBlueColor
                                    : LightMode.whiteColor,
                                size: 3.w,
                                weight: FontWeight.w500),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 25.h,
                        right: 6.w,
                        left: 6.w,
                        bottom: -3.h,
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: LightMode.whiteBlueColor,
                            borderRadius: BorderRadius.circular(5.w),
                            border: Border.all(
                                color: LightMode.mainColor, width: 1.5),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextNormalWidget(
                                    text: "Personal Details",
                                    color: LightMode.orangeColor,
                                    size: 3.5.w,
                                    weight: FontWeight.w700),
                                const SizedBox(height: 15),
                                _buildProfileOption(
                                    icon: Icons.person,
                                    title: "Edit My Profile",
                                    onTap: () => controller.setData()),
                                const SizedBox(height: 15),
                                _buildProfileOption(
                                    icon: Icons.key,
                                    title: "Change My Password",
                                    onTap: () =>
                                        Get.to(() => const ChangePassword())),
                                const SizedBox(height: 15),
                                _buildProfileOption(
                                    icon: Icons.shopping_cart_outlined,
                                    title: "My Orders",
                                    onTap: () =>
                                        Get.to(() => const MyOrders())),
                                const Divider(
                                    color: LightMode.orangeColor,
                                    thickness: 2,
                                    height: 30),
                                TextNormalWidget(
                                    text: "App Preferences",
                                    color: LightMode.orangeColor,
                                    size: 3.5.w,
                                    weight: FontWeight.w700),
                                const SizedBox(height: 15),
                                InkWell(
                                  onTap: () => controller.changeDark(),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.dark_mode,
                                              color: LightMode.orangeColor,
                                              size: 4.5.w),
                                          const SizedBox(width: 10),
                                          TextNormalWidget(
                                              text: "Night Mode",
                                              color: LightMode.mainColor,
                                              size: 3.5.w,
                                              weight: FontWeight.w600),
                                        ],
                                      ),
                                      Switch(
                                          activeThumbColor:
                                              LightMode.orangeColor,
                                          activeTrackColor:
                                              LightMode.darkMainColor,
                                          inactiveThumbColor:
                                              LightMode.orangeColor,
                                          inactiveTrackColor:
                                              LightMode.whiteBlueColor,
                                          trackOutlineColor:
                                              const WidgetStatePropertyAll(
                                                  LightMode.orangeColor),
                                          value: ThemeService.isDark,
                                          onChanged: (val) =>
                                              controller.changeDark())
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                InkWell(
                                  onTap: () {
                                    bottomSheetMessage(
                                        context: context,
                                        onPressNo: () => Get.back(),
                                        onPressYes: () =>
                                            controller.changLang(),
                                        title: "Switch Language",
                                        body:
                                            "Are you sure you want to switch your language to ${sharedPreferences!.getString("Lang") == "Ar" ? "English" : "Arabic"}?");
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.language,
                                              color: LightMode.orangeColor,
                                              size: 4.5.w),
                                          const SizedBox(width: 10),
                                          TextNormalWidget(
                                              text: "Language",
                                              color: LightMode.mainColor,
                                              size: 3.5.w,
                                              weight: FontWeight.w600),
                                        ],
                                      ),
                                      TextNormalWidget(
                                          text: sharedPreferences!
                                                      .getString("Lang") ==
                                                  "Ar"
                                              ? "AR     "
                                              : "EN     ",
                                          color: LightMode.mainColor,
                                          size: 3.5.w,
                                          weight: FontWeight.w600),
                                    ],
                                  ),
                                ),
                                const Divider(
                                    color: LightMode.orangeColor,
                                    thickness: 2,
                                    height: 30),
                                TextNormalWidget(
                                    text: "Support & Legal",
                                    color: LightMode.orangeColor,
                                    size: 3.5.w,
                                    weight: FontWeight.w700),
                                const SizedBox(height: 15),
                                _buildProfileOption(
                                    icon: Icons.contact_phone_outlined,
                                    title: "Contact Us",
                                    onTap: () =>
                                        Get.to(() => const ContactUs())),
                                const SizedBox(height: 15),
                                _buildProfileOption(
                                    icon: Icons.people,
                                    title: "About Us",
                                    onTap: () => Get.to(() => const AboutUs())),
                                const Divider(
                                    color: LightMode.orangeColor,
                                    thickness: 2,
                                    height: 30),
                                TextNormalWidget(
                                    text: "Account",
                                    color: LightMode.orangeColor,
                                    size: 3.5.w,
                                    weight: FontWeight.w700),
                                const SizedBox(height: 15),
                                _buildProfileOption(
                                    icon: Icons.delete,
                                    title: "Delete My Account",
                                    color: LightMode.redColor,
                                    onTap: () =>
                                        Get.to(() => const DeleteAccount())),
                                const SizedBox(height: 15),
                                InkWell(
                                  onTap: () {
                                    bottomSheetMessage(
                                        body:
                                            "Are you sure you want sign out at your account?",
                                        context: context,
                                        onPressNo: () => Get.back(),
                                        onPressYes: () => controller.logOut(),
                                        title: "Sign Out");
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout,
                                          color: LightMode.orangeColor,
                                          size: 4.5.w),
                                      const SizedBox(width: 10),
                                      TextNormalWidget(
                                          text: "Sign Out",
                                          color: LightMode.mainColor,
                                          size: 3.5.w,
                                          weight: FontWeight.w600),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      Color? color}) {
    Color itemColor = color ?? LightMode.mainColor;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color ?? LightMode.orangeColor, size: 4.5.w),
          const SizedBox(width: 10),
          TextNormalWidget(
              text: title,
              color: itemColor,
              size: 3.5.w,
              weight: FontWeight.w600),
        ],
      ),
    );
  }
}
