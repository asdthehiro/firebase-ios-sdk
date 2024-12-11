import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_exit_card.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/sign_in_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/sign_up_widget.dart';
import 'package:provider/provider.dart';
import 'package:group_radio_button/group_radio_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false)
        .updateSelectedIndex(0, notify: false);
    super.initState();
  }

  bool scrolled = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Provider.of<AuthProvider>(context, listen: false).selectedIndex !=
            0) {
          Provider.of<AuthProvider>(context, listen: false)
              .updateSelectedIndex(0);
          return false;
        } else {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          } else {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) => const CustomExitCard());
          }
        }
        return false;
      },
      child: Scaffold(
        body: Consumer<AuthProvider>(builder: (context, authProvider, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                        height: 200,
                        decoration: BoxDecoration(color: Colors.white)),
                    // Image.asset(Images.loginBg,
                    //     fit: BoxFit.cover,
                    //     height: 200,
                    //     opacity: const AlwaysStoppedAnimation(.15)),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .05),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Images.splashLogo,
                                width: 130, height: 100)
                          ]),
                    ),
                  ],
                ),
                AnimatedContainer(
                  transform: Matrix4.translationValues(0, -20, 0),
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(Dimensions.radiusExtraLarge))),
                  duration: const Duration(seconds: 2),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeDefault),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.all(Dimensions.marginSizeLarge),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                // left: Dimensions.marginSizeLarge,
                                // right: Dimensions.marginSizeLarge,
                                top: Dimensions.marginSizeLarge,
                                bottom: 0,
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () =>
                                          authProvider.updateSelectedIndex(0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'sign_in', context)!,
                                                style: authProvider
                                                            .selectedIndex ==
                                                        0
                                                    ? titleRegular.copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: Dimensions
                                                            .fontSizeLarge)
                                                    : titleRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeLarge)),
                                            Container(
                                              height: 3,
                                              width: 50,
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(
                                                          Dimensions
                                                              .paddingSizeSmall),
                                                  color: authProvider
                                                              .selectedIndex ==
                                                          0
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.transparent),
                                            )
                                          ])),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraLarge),
                                  InkWell(
                                      onTap: () =>
                                          authProvider.updateSelectedIndex(1),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'sign_up', context)!,
                                                style: authProvider
                                                            .selectedIndex ==
                                                        1
                                                    ? titleRegular.copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: Dimensions
                                                            .fontSizeLarge)
                                                    : titleRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeLarge)),
                                            Container(
                                              height: 3,
                                              width: 50,
                                              margin:
                                                  const EdgeInsets.only(top: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(
                                                          Dimensions
                                                              .paddingSizeSmall),
                                                  color: authProvider
                                                              .selectedIndex ==
                                                          1
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Colors.transparent),
                                            )
                                          ]))
                                ],
                              ),
                            ),
                          ),
                          authProvider.selectedIndex == 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: RadioGroup<int>.builder(
                                    direction: Axis.horizontal,
                                    groupValue: authProvider.methodIndex,
                                    onChanged: (value) => authProvider
                                        .updateMethodIndex(value ?? 0),
                                    items: [0, 1],
                                    itemBuilder: (item) => RadioButtonBuilder(
                                      (item == 0)
                                          ? getTranslated('mobile', context)!
                                          : getTranslated('EMAIL', context)!,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          authProvider.selectedIndex == 0
                              ? SignInWidget(method: authProvider.methodIndex)
                              : const SignUpWidget(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}