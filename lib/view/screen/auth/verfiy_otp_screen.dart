import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
//add the next at terminal
//flutter pub add flutter_otp_text_field
import 'package:flutter_sixvalley_ecommerce/localization/app_localization.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class ConfirmMobileScreen extends StatefulWidget {
  ConfirmMobileScreen({super.key, required this.phone});
  String phone;
  @override
  State<ConfirmMobileScreen> createState() => _ConfirmMobileScreenState();
}

class _ConfirmMobileScreenState extends State<ConfirmMobileScreen> {
  String? verificationCode;
  Timer? _timer;
  // int _remainingTime = 100;
  // bool _isButtonDisabled = false;

  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).getGuestIdUrl();
    super.initState();
    // _startTimer();
  }

  // void _startTimer() {
  //   setState(() {
  //     _isButtonDisabled = true;
  //   });
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_remainingTime > 0) {
  //         _remainingTime--;
  //       } else {
  //         _isButtonDisabled = false;
  //         _timer?.cancel();
  //       }
  //     });
  //   });
  // }

  route(bool isRoute, String token, String errorMsg) async {
    if (isRoute) {
      //nav to home screen
      await Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(context);
      Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(builder: (_) => const DashBoardScreen()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalization.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthProvider>(builder: (context, value, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      start: 78,
                      end: 78,
                    ),
                    child: Text(
                      locale.locale.languageCode == "en"
                          ? "confirm mobile number"
                          : " تأكيد رقم الهاتف",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFF292929),
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.50,
                      ),
                    ),
                  ),
                  // const Spacer(),
                ],
              ),
              SizedBox(
                height: 37,
              ),
              // Center(
              //   child: Container(
              //     width: MediaQuery.sizeOf(context).width,
              //     height: 275,
              //     decoration: const BoxDecoration(color: Color(0xFFF4F7FA)),
              //     child: Container(
              //       width: 252,
              //       height: 144.16,
              //       decoration: const BoxDecoration(
              //         image: DecorationImage(
              //           image: AssetImage(
              //             'assets/images/confirm_email.png',

              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 43,
              ),
              Center(
                child: Text(
                  locale.locale.languageCode == "en"
                      ? "Enter code"
                      : "أدخل الرمز",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF292929),
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.50,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              OtpTextField(
                numberOfFields: 4,
                showFieldAsBox: true,
                onCodeChanged: (String code) {},
                onSubmit: (String verificationCodeSumbit) {
                  verificationCode = verificationCodeSumbit;
                }, // end onSubmit
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // onPressedLogin();

                    value.verifyCode(
                        widget.phone, verificationCode ?? "", route);
                  },
                  child: SizedBox(
                    width: 120,
                    height: 35,
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff8BBF4D),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          locale.locale.languageCode == "ar"
                              ? "تأكيد الرمز"
                              : "Confirm code",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // onPressed: _authController.login,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 100
              // ),
              // if(_isButtonDisabled)Center(child: Text(locale.locale.languageCode == "en" ?  "resend code at $_remainingTime" : "يمكنك إعادة إرسال الرمز في $_remainingTime")),
              // const SizedBox(height: 40,),
              // InkWell(
              //   onTap: ()async {
              //     if(_isButtonDisabled)return;
              //     await resendOTP({"user_id":widget.user.id.toString()});
              //     setState(() {
              //       _isButtonDisabled = true;
              //       _remainingTime = 100;
              //     });
              //     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              //       setState(() {
              //         if (_remainingTime > 0) {
              //           _remainingTime--;
              //         } else {
              //           _isButtonDisabled = false;
              //           _timer?.cancel();
              //         }
              //       });
              //     });
              //   },
              //   child: Center(
              //     child: Text(
              //       locale.locale.languageCode == "ar" ?"أعد إرسال الرمز" :"resend code",
              //       textAlign: TextAlign.right,
              //       style: TextStyle(
              //         color: const Color(0xFF9D9D9D),
              //         fontSize: 14,
              //         fontWeight: FontWeight.w400,
              //         letterSpacing: -0.50,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        );
      }),
    );
  }
}
