import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/login_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/verfiy_otp_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/social_login_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';


class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});

  @override
  SignInWidgetState createState() => SignInWidgetState();
}

class SignInWidgetState extends State<SignInWidget> {
  TextEditingController? _emailController;
  // TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    // _passwordController = TextEditingController();
    _emailController!.text = (Provider.of<AuthProvider>(context, listen: false).getUserEmail());
    // _passwordController!.text = (Provider.of<AuthProvider>(context, listen: false).getUserPassword());
  }

  @override
  void dispose() {
    _emailController!.dispose();
    // _passwordController!.dispose();
    super.dispose();
  }

  final FocusNode _emailNode = FocusNode();
  // final FocusNode _passNode = FocusNode();
  LoginModel loginBody = LoginModel();

  void loginUser() async {
    if (_formKeyLogin!.currentState!.validate()) {
      _formKeyLogin!.currentState!.save();
      String email = _emailController!.text.trim();
      // String password = _passwordController!.text.trim();
      if(!Provider.of<AuthProvider>(context, listen: false).isGuestIdExist()){
        Provider.of<AuthProvider>(context, listen: false).getGuestIdUrl();
      }
      // if (Provider.of<AuthProvider>(context, listen: false).isRemember!) {
      //   Provider.of<AuthProvider>(context, listen: false).saveUserEmail(email, password);
      // } else {
      //   Provider.of<AuthProvider>(context, listen: false).clearUserEmailAndPassword();
      // }
      loginBody.email = email;
      // loginBody.password = password;

      loginBody.guestId = Provider.of<AuthProvider>(context, listen: false).getGuestToken()??'1';
      if(email.isEmpty){
        showCustomSnackBar(getTranslated('user_name_is_required', context), context);
      // }else if (password.isEmpty){
      //   showCustomSnackBar(getTranslated('password_is_required', context), context);
      // }else if (password.length<8){
      //   showCustomSnackBar(getTranslated('minimum_password_length', context), context);
      }else{
        await Provider.of<AuthProvider>(context, listen: false).loginPhone(email, route);
      }

    }
  }

  

  route(bool isRoute, String? token, String? errorMessage) async {
    if (isRoute) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ConfirmMobileScreen(phone: "${_emailController?.text}",),));
     }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage!), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).isRemember;

    return Consumer<AuthProvider>(
      builder: (context,authProvider,_) {
        return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Form(
            key: _formKeyLogin,
            child: Column(children: [
                // Hero(
                //   tag: 'user',
                //   child: CustomTextField(
        
                //     hintText: getTranslated('enter_phone_number', context),
                //     labelText: getTranslated('phone', context),
                //     focusNode: _emailNode,
                //     // nextFocus: _passNode,
                //     isRequiredFill: true,
                //     prefixIcon: Images.username,
                //     inputType: TextInputType.emailAddress,
                //     controller: _emailController,
                //     showLabelText: true,
                //       required: true,
                //       validator: (value) =>ValidateCheck.validateEmptyText(value, "enter_email_or_mobile")),
                // ),
        
                Container(
                      margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault, top: Dimensions.marginSizeSmall),
                      child: CustomTextField(
                        hintText: getTranslated('enter_mobile_number', context),
                        labelText: getTranslated('enter_mobile_number', context),
                        controller: _emailController,
                        focusNode: _emailNode,
                        // nextFocus: _passwordFocus,
                        required: true,
                        showCodePicker: true,
                        countryDialCode: authProvider.countryDialCode,
                        onCountryChanged: (CountryCode countryCode) {
                          authProvider.countryDialCode = countryCode.dialCode!;
                          authProvider.setCountryCode(countryCode.dialCode!);
                        },
                        isAmount: true,
                        validator: (value)=> ValidateCheck.validateEmptyText(value, "phone_must_be_required"),
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.phone,
                      ),
                    ),
                    
                // const SizedBox(height: Dimensions.paddingSizeDefault,),
        
        
                // CustomTextField(
                //   showLabelText: true,
                //     required: true,
                //   labelText: getTranslated('password', context),
                //   hintText: getTranslated('enter_your_password', context),
                //   inputAction: TextInputAction.done,
                //   isPassword: true,
                //   prefixIcon: Images.pass,
                //   focusNode: _passNode,
                //   controller: _passwordController,
                //     validator: (value) =>ValidateCheck.validateEmptyText(value, 'ENTER_YOUR_PASSWORD')),
        
        
        
        
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                    Row(children: [
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child){
                        return InkWell(onTap: ()=> authProvider.updateRemember(),
                          child: SizedBox(width : 20, height : 20,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.75), width: 1.5),
                              borderRadius: BorderRadius.circular(6)
                                ),
                              child: Icon(CupertinoIcons.checkmark_alt,size: 15,
                                color: authProvider.isRemember!? Theme.of(context).primaryColor.withOpacity(.75): Colors.transparent,),
                            ),
                          ),
                        );
                      }),
        
        
                    Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Text(getTranslated('remember', context)!, style: textRegular),),
                  ],),
        
                    // InkWell(
                    //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgetPasswordScreen())),
                    //   child: Text('${getTranslated('forget_password', context)!}?',
                    //       style: titilliumRegular.copyWith(
                    //       color: ColorResources.getPrimary(context))),
                    // ),
                //   ],
                // ),
        
        
        
                Container(margin: const EdgeInsets.only(bottom: 20, top: 30),
                  child: Provider.of<AuthProvider>(context).isLoading ?
                  Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,),),) :
                  Hero(tag: "onTap",
                  child: CustomButton(onTap: loginUser, buttonText: getTranslated('login', context))),),
                const SizedBox(width: Dimensions.paddingSizeDefault),
        
        
        
                const SocialLoginWidget(),
        
                Consumer<AuthProvider>(
                  builder: (context, authProvider,_) {
                    return GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print("===Guest ID===${authProvider.getGuestToken()}====>");
                        }
                        if (!authProvider.isLoading) {
                          Provider.of<AuthProvider>(context, listen: false).getGuestIdUrl();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
                        }
                      },
                      child: Container(
        
                        width: double.infinity, height: 40, alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent, borderRadius: BorderRadius.circular(6),),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
        
                            Text(getTranslated('continue_as', context)!, style: titleRegular.copyWith(color: ColorResources.getHint(context))),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                            Text(getTranslated('guest', context)!, style: titleHeader),
        
        
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        );
      }
    );


  }


}
