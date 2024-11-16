import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_image.dart';
import 'package:provider/provider.dart';

class CustomCheckBox extends StatelessWidget {
  final int index;
  final bool isDigital;
  final String? icon;
  final String name;
  final String title;
  const CustomCheckBox(
      {super.key,
      required this.index,
      this.isDigital = false,
      this.icon,
      required this.name,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () {
            (index == 2)
                ? order.setOfflineChecked('cod', index, name)
                : order.setDigitalPaymentMethodName(index, name, context);
          },
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),
            child: Row(children: [
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor:
                      Provider.of<ThemeProvider>(context, listen: false)
                              .darkTheme
                          ? Theme.of(context).hintColor.withOpacity(.5)
                          : Theme.of(context).primaryColor.withOpacity(.25),
                ),
                child: Checkbox(
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          Dimensions.paddingSizeExtraLarge)),
                  value: order.paymentMethodIndex == index,
                  activeColor: Colors.green,
                  onChanged: (bool? isChecked) {
                    print(order.paymentMethodIndex);
                    (index == 2)
                        ? order.setOfflineChecked('cod', index, name)
                        : order.setDigitalPaymentMethodName(
                            index, name, context);
                  },
                ),
              ),
              SizedBox(
                  width: (index == 2) ? 25 : 40,
                  child: (index == 2)
                      ? Image.asset(icon!)
                      : CustomImage(image: icon!)),
              Text(
                title,
                style: textRegular.copyWith(),
              ),
            ]),
          ),
        );
      },
    );
  }
}
