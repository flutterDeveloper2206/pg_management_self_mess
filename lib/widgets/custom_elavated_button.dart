




import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/image_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/theme/app_style.dart';

class AppElevatedButton extends StatefulWidget {
  final String buttonName;
  final void Function() onPressed;
  final Color? textColor;
  final Color? buttonColor;
  final FontWeight? fontWeight;
  final double? radius;
  final bool? isLoading;
  final double? fontSize;
  final bool? showTextIcon;
   bool? hasGradient=true;
  final String? textIcon;
  final Color? borderColor;

   AppElevatedButton(
      {super.key,
      required this.buttonName,
      required this.onPressed,
      this.textColor,
      this.textIcon,
      this.borderColor,
      this.fontWeight,
      this.fontSize,
      this.buttonColor,
      this.radius,
      this.showTextIcon,
      this.hasGradient=true,
      this.isLoading = false});

  @override
  State<AppElevatedButton> createState() => _AppElevatedButtonState();
}

class _AppElevatedButtonState extends State<AppElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(40),
      width: double.infinity,
      decoration: BoxDecoration(
        border:  widget.hasGradient??false? null:Border.all(color: ColorConstant.primary,width: getWidth(1)),
       color:widget.buttonColor?? ColorConstant.primary,
        boxShadow: widget.hasGradient??false?[
          BoxShadow(
              blurRadius: 10.0,
              offset: const Offset(4, 8),
              color: ColorConstant.primary.withOpacity(0.6)),
        ]:null,
        borderRadius: const BorderRadius.all(Radius.circular(8)),

      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        child: !widget.isLoading!
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.showTextIcon ?? false
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SvgPicture.asset(
                            widget.textIcon ?? ImageConstant.icClose,
                            height: 23,
                          ),
                        )
                      : const SizedBox(),
                  Text(
                    widget.buttonName.toString(),
                    style: AppStyle.txtGilroyBold.copyWith(
                        color: widget.textColor ?? ColorConstant.primaryWhite,
                        fontWeight: widget.fontWeight ?? FontWeight.w400,
                        fontSize: getFontSize(widget.fontSize ?? 16)),
                  ),
                ],
              )
            : Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                  height: getWidth(25),
                  width: getWidth(25),
                  child: const CircularProgressIndicator(
                    color: ColorConstant.primaryWhite,
                    strokeWidth: 2,
                  )),
            ),
      ),
    );
  }
}
