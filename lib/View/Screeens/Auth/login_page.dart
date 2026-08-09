import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:tharwat_pharmacy/Controller/Auth/login_controller.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_color.dart';
import 'package:tharwat_pharmacy/Core/Constant/theme_service.dart';
import 'package:tharwat_pharmacy/Core/class/status_request.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/forget_pass.dart';
import 'package:tharwat_pharmacy/View/Screeens/Auth/sign_up.dart';
import 'package:tharwat_pharmacy/View/Widget/Auth/body_auth_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/app_bar_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/bottom_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/loading.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_click_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_field_widget.dart';
import 'package:tharwat_pharmacy/View/Widget/PublicWidget/text_normal_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // تم حذف Get.put من هنا لمنع تسريب الذاكرة وإعادة البناء غير الضرورية

    return Scaffold(
      backgroundColor: ThemeService.backgroundColor, // استخدام الثيم الجديد
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarPageWidget(back : false,onPress:  null,title:  "Sign in",colorText:  LightMode.mainColor,colorIcon:  LightMode.mainColor),
            bodyAuthTextPageWidget("Welcome Back, again!", "Please complete your data to get you in your account."),
            GetBuilder<LoginController>(
              init: LoginController(), // <-- الطريقة الصحيحة للتهيئة داخل الـ GetBuilder
              builder: (controller) => Form(
                  key: controller.loginKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5.w, left: 5.w),
                        child: TextFieldWidget(
                          controller:   controller.emailController,hintText:  "Email",iconic:  false,obscure:  false,
                               validator:  (val) {
                              return controller.emailValidtor(val!);
                            },keyBoard:  TextInputType.emailAddress,onPress:  () {},icon:  Icons.email),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 5.w, left: 5.w),
                        child: TextFieldWidget(

                          controller:   controller.passwordController,
                            hintText: "Password",
                           iconic:  true,
                           obscure:  controller.show,
                               validator:  (val) {
                              return controller.passwordValidtor(val!);
                            },
                           keyBoard:  TextInputType.visiblePassword,
                               onPress:  () {
                              controller.changeShow();
                            },
                       icon:      Icons.lock),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      controller.statuesRequest == StatuesRequest.loading
                          ? LoadingWidget(height:7.h)
                          : ButtonWidget(
                          colorBorder: ThemeService.primaryColor,
                          colorFill: ThemeService.primaryColor,
                          colorText: LightMode.whiteColor,
                          width: 90.w,
                          text: "Login",
                          onPress: () {
                            controller.login();
                          },
                          size: 5.w),
                      SizedBox(
                        height: 3.w,
                      ),
                      TextClickWidget(text: "Did you forget your password ? ",decoration:  true,onPress:  () {
                        Get.to(() => const ForgetPass());
                      },color:  LightMode.mainColor,size:  3.w),
                      SizedBox(
                        height: 2.h,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextNormalWidget(
                                  text: "Don't have an account ?",
                                 color:  ThemeService.textColor, // استخدام الثيم
                                 size:  3.5.w,
                                 weight:  FontWeight.w500),
                              TextClickWidget(text: "Sign up",decoration:  true,onPress:  () {
                                Get.to(() => const SignUp());
                              },  color:  LightMode.mainColor,size:  4.w),
                            ],
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}