import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Auth/sign_up_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/login_page.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/terms_of_policy.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/terms_of_services.dart';
import 'package:tharwat_pharmacy/View/Widget/Auth/body_auth_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/Auth/drop_down_list_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_click_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_field_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarPageWidget(
                back: true,
                onPress: () => Get.offAll(() => const LoginPage()),
                title: "Your information",
                colorText: LightMode.mainColor,
                colorIcon: LightMode.mainColor),
            bodyAuthTextPageWidget("Please, Complete your information.",
                "Don’t worry, your data will remain private and only you can see it."),
            GetBuilder<SignUpController>(
              init: SignUpController(),
              builder: (controller) => Form(
                  key: controller.signUpKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                        child: TextFieldWidget(
                            controller: controller.userNameController,
                            hintText: "User Name",
                            icon: Icons.person,
                            validator: (val) => controller.userNameValidtor(val!)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                        child: TextFieldWidget(
                            controller: controller.emailController,
                            hintText: "Email",
                            icon: Icons.email,
                            keyBoard: TextInputType.emailAddress,
                            validator: (val) => controller.emailValidtor(val!)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                        child: TextFieldWidget(
                            controller: controller.passwordController,
                            hintText: "Password",
                            icon: Icons.lock,
                            obscure: controller.show_1,
                            iconic: true,
                            onPress: () => controller.changeShow_1(),
                            validator: (val) => controller.passwordValidtor(val!)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                        child: TextFieldWidget(
                            controller: controller.passwordConfirmController,
                            hintText: "Confirm Password",
                            icon: Icons.lock,
                            obscure: controller.show_2,
                            iconic: true,
                            onPress: () => controller.changeShow_2(),
                            validator: (val) => controller.passwordConfirmValidtor(val!)),
                      ),
                      DropDownListWidget(
                        title: "Governorate",
                        value: controller.governorateController,
                        onChanged: (p0) => controller.changeGover(p0),
                        itemes: List.generate(controller.governorateList.length, (index) => DropdownMenuItem(
                            value: controller.governorateList[index].name,
                            onTap: () {
                              controller.countryId = controller.governorateList[index].id.toString();
                              controller.governorateController = controller.governorateList[index].name;
                              Get.appUpdate();
                            },
                            child: TextNormalWidget(text: controller.governorateList[index].name!, color: LightMode.mainColor, size: 4.w, weight: FontWeight.w600))),
                      ),
                      DropDownListWidget(
                        title: "City",
                        value: controller.cityController,
                        onChanged: (p0) => controller.changeCity(p0),
                        itemes: List.generate(controller.cityList.length, (index) => DropdownMenuItem(
                            value: controller.cityList[index].name,
                            onTap: () {
                              controller.cityId = controller.cityList[index].id.toString();
                              controller.cityController = controller.cityList[index].name;
                              Get.appUpdate();
                            },
                            child: TextNormalWidget(text: controller.cityList[index].name!, color: LightMode.mainColor, size: 4.w, weight: FontWeight.w600))),
                      ),
                      DropDownListWidget(
                        title: "District",
                        value: controller.districtController,
                        onChanged: (p0) => controller.changeDistric(p0),
                        itemes: List.generate(controller.districtList.length, (index) => DropdownMenuItem(
                            value: controller.districtList[index].name,
                            onTap: () {
                              controller.districtId = controller.districtList[index].id.toString();
                              controller.districtController = controller.districtList[index].name;
                              Get.appUpdate();
                            },
                            child: TextNormalWidget(text: controller.districtList[index].name!, color: LightMode.mainColor, size: 4.w, weight: FontWeight.w600))),
                      ),
                      DropDownListGenderWidget(
                          title: "Gender",
                          value: controller.gender,
                          valueList: controller.genderList,
                          onChange: (val) => controller.changeGender(val)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                        child: TextFieldWidget(
                            controller: controller.phoneController,
                            hintText: "Phone Number",
                            icon: Icons.phone,
                            keyBoard: TextInputType.phone,
                            validator: (val) => controller.phoneValidtor(val!)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                        child: TextFieldWidget(
                            controller: controller.ageController,
                            hintText: "Age",
                            icon: Icons.person_2_outlined,
                            keyBoard: TextInputType.number,
                            validator: (val) => controller.ageValidtor(val!)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                          children: [
                            Checkbox(
                                activeColor: LightMode.mainColor,
                                value: controller.check,
                                onChanged: (val) => controller.confirmCheck()),
                            SizedBox(
                              width: 75.w,
                              child: Wrap(
                                children: [
                                  TextNormalWidget(text: "By clicking, you agree to our ", color: ThemeService.textColor, size: 3.w, weight: FontWeight.w400),
                                  TextClickWidget(text: "Terms Of Service ", decoration: true, onPress: () => Get.to(() => const TermsOfServices()), color: LightMode.mainColor, size: 3.w),
                                  TextNormalWidget(text: "and that you have read our ", color: ThemeService.textColor, size: 3.w, weight: FontWeight.w400),
                                  TextClickWidget(text: "Terms Of Policy", decoration: true, onPress: () => Get.to(() => const TermsOfPolicy()), color: LightMode.mainColor, size: 3.w),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      controller.statuesRequest == StatuesRequest.loading
                          ? LoadingWidget(height: 7.h)
                          : ButtonWidget(
                          colorBorder: ThemeService.primaryColor,
                          colorFill: ThemeService.primaryColor,
                          colorText: LightMode.whiteColor,
                          width: 90.w,
                          text: "Next",
                          onPress: () => controller.signUp(),
                          size: 5.w),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextNormalWidget(text: "Already have an account ?", color: ThemeService.textColor, size: 3.5.w, weight: FontWeight.w500),
                          TextClickWidget(text: "Login", decoration: true, onPress: () => Get.offAll(() => const LoginPage()), color: LightMode.mainColor, size: 4.w),
                        ],
                      ),
                    ],
                  )),
            ),
            SizedBox(height: 10.w),
          ],
        ),
      ),
    );
  }
}