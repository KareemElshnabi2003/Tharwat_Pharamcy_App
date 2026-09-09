import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Home/Profile/profile_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_api.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Widget/Auth/drop_down_list_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/bottom_sheet_message.dart';
import 'package:tharwat_pharmacy/View/Widget/HomePage/bottom_sheet_update_img.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_field_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';
import 'package:tharwat_pharmacy/main.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: GetBuilder<ProfileController>(
        builder: (controller) => controller.cityList.isEmpty
            ? LoadingWidget(height: 80.h)
            : SingleChildScrollView(
                child: Form(
                  key: controller.editKey,
                  child: Container(
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
                            color: ThemeService.isDark
                                ? LightMode.nightColor
                                : LightMode.mainColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(7.w),
                                bottomLeft: Radius.circular(7.w)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: controller.fileImg == null
                                        ? sharedPreferences!
                                                    .getString("image") ==
                                                "null"
                                            ? AssetImage(AppImages.noImage)
                                                as ImageProvider
                                            : NetworkImage(
                                                "${AppApi.imgUrl}/${sharedPreferences!.getString("image")}")
                                        : FileImage(controller.fileImg!),
                                    backgroundColor: LightMode.greyColor,
                                    radius: 10.w,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: InkWell(
                                      onTap: () {
                                        bottomSheetUpdateImage(
                                            context: context,
                                            onPressCamera: () => controller
                                                .pickImageFromCamera(),
                                            onPressDelete: () {
                                              controller.fileImg = null;
                                              Get.appUpdate();
                                            },
                                            onPressGellery: () => controller
                                                .pickImageFromGellary());
                                      },
                                      child: CircleAvatar(
                                        radius: 3.5.w,
                                        backgroundColor: LightMode.whiteColor,
                                        child: Icon(Icons.edit,
                                            color: LightMode.orangeColor,
                                            size: 4.w),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextNormalWidget(
                                  text: sharedPreferences!.getString("name") ??
                                      "",
                                  color: LightMode.whiteColor,
                                  size: 4.w,
                                  weight: FontWeight.w700),
                              TextNormalWidget(
                                  text: sharedPreferences!.getString("email") ??
                                      "",
                                  color: ThemeService.isDark
                                      ? LightMode.greyColor
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
                          bottom: 5.w,
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
                                  TextFieldWidget(
                                      controller: controller.userNameController,
                                      hintText: "User Name",
                                      icon: Icons.person,
                                      validator: (val) =>
                                          controller.userNameValidtor(val!)),
                                  DropDownListWidget(
                                    edit: true,
                                    itemes: List.generate(
                                      controller.governorateList.length,
                                      (index) => DropdownMenuItem(
                                          onTap: () {
                                            controller.cityController = null;
                                            controller.districtController =
                                                null;
                                            controller.countryId = controller
                                                .governorateList[index].id
                                                .toString();
                                            controller.governorateController =
                                                controller
                                                    .governorateList[index]
                                                    .name;
                                            Get.appUpdate();
                                          },
                                          value: controller
                                              .governorateList[index].name,
                                          child: TextNormalWidget(
                                              text: controller
                                                  .governorateList[index].name,
                                              color: LightMode.mainColor,
                                              size: 4.w,
                                              weight: FontWeight.w600)),
                                    ),
                                    value: controller.governorateController,
                                    title: "Governorate",
                                    onChanged: (p0) =>
                                        controller.changeGover(p0),
                                  ),
                                  DropDownListWidget(
                                    edit: true,
                                    itemes: List.generate(
                                      controller.cityList.length,
                                      (index) => DropdownMenuItem(
                                          onTap: () {
                                            controller.districtController =
                                                null;
                                            controller.cityId = controller
                                                .cityList[index].id
                                                .toString();
                                            controller.cityController =
                                                controller.cityList[index].name;
                                            Get.appUpdate();
                                          },
                                          value:
                                              controller.cityList[index].name,
                                          child: TextNormalWidget(
                                              text: controller
                                                  .cityList[index].name,
                                              color: LightMode.mainColor,
                                              size: 4.w,
                                              weight: FontWeight.w600)),
                                    ),
                                    value: controller.cityController,
                                    title: "City",
                                    onChanged: (p0) =>
                                        controller.changeCity(p0),
                                  ),
                                  DropDownListWidget(
                                      edit: true,
                                      itemes: List.generate(
                                        controller.districtList.length,
                                        (index) => DropdownMenuItem(
                                            onTap: () {
                                              controller.districtId = controller
                                                  .districtList[index].id
                                                  .toString();
                                              controller.districtController =
                                                  controller
                                                      .districtList[index].name;
                                              Get.appUpdate();
                                            },
                                            value: controller
                                                .districtList[index].name,
                                            child: SizedBox(
                                                width: 55.w,
                                                child: TextNormalWidget(
                                                    text: controller
                                                        .districtList[index]
                                                        .name,
                                                    color: LightMode.mainColor,
                                                    size: 3.6.w,
                                                    weight: FontWeight.w600))),
                                      ),
                                      value: controller.districtController,
                                      title: "District",
                                      onChanged: (p0) =>
                                          controller.changeDistric(p0)),
                                  const SizedBox(height: 10),
                                  TextFieldWidget(
                                      controller: controller.phoneController,
                                      hintText: "Phone",
                                      icon: Icons.phone,
                                      validator: (val) =>
                                          controller.phoneValidtor(val!)),
                                  const SizedBox(height: 30),
                                  controller.statuesRequest ==
                                          StatuesRequest.loading
                                      ? LoadingWidget(height: 7.h)
                                      : SizedBox(
                                          height: 6.h,
                                          child: ButtonWidget(
                                              colorBorder:
                                                  ThemeService.primaryColor,
                                              colorFill:
                                                  ThemeService.primaryColor,
                                              colorText: LightMode.whiteColor,
                                              margin: false,
                                              onPress: () {
                                                bottomSheetMessage(
                                                  body:
                                                      "Are you sure you want to save your new data?",
                                                  title: "Save New Data?",
                                                  context: context,
                                                  onPressNo: () => Get.back(),
                                                  onPressYes: () => controller
                                                      .updateProfile(),
                                                );
                                              },
                                              size: 4.w,
                                              text: "Confirm",
                                              width: 80.w),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6.h,
                          left: 5.w,
                          child: IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(Icons.arrow_back_ios,
                                  color: LightMode.whiteColor, size: 6.w)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
