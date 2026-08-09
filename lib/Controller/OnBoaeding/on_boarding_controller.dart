import 'package:get/get.dart';
import 'package:tharwat_pharmacy/Core/Constant/app_images.dart';
import 'package:tharwat_pharmacy/main.dart';

class OnBoardingController extends GetxController {
  int indexList = 0;

  List onBoardingList = sharedPreferences!.getString("Lang") == "Ar"
      ? [
          {
            "title": "إعادة تعبئة الوصفات الطبية بسهولة",
            "body": "أعد تعبئة وصفاتك الطبية بسهولة ببضع نقرات على شاشتك.",
            "img": AppImages.onBoard_1
          },
          {
            "title": "احصل على نصائح صحية مخصصة",
            "body": "من السهل العثور على الصيدلية القريبة منك بنقرة واحدة.",
            "img": AppImages.onBoard_2
          },
          {
            "title": "تابع تقدمك الصحي",
            "body": "راقب صحتك وسجل أدويتك, وابقَ على اطلاع.",
            "img": AppImages.onBoard_3
          },
        ]
      : [
          {
            "title": "Easy Prescription Refills",
            "body":
                "Refill your prescriptions effortlessly with just a few taps on your screen.",
            "img": AppImages.onBoard_1
          },
          {
            "title": "Get Personalized Health Tips",
            "body":
                "It's easy to find the pharmacy near your location with just one click.",
            "img": AppImages.onBoard_2
          },
          {
            "title": "Track Your Health Progress",
            "body":
                "Monitor your health, medication history, and stay informed.",
            "img": AppImages.onBoard_3
          },
        ];

  changIndex(i) {
    indexList = i;
    update();
  }
}
