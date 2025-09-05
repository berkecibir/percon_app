import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percon_app/core/border/app_border_radius.dart';
import 'package:percon_app/core/config/asset/app_vectors.dart';
import 'package:percon_app/core/sizes/app_sizes.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';

class CustomButton extends StatelessWidget {
  final IconData? iconData;
  final String? svgIconPath;
  final Function() onTap;
  final Widget child;
  const CustomButton({
    required this.onTap,
    required this.child,
    super.key,
    this.iconData,
    this.svgIconPath,
  });

  factory CustomButton.googleSignIn({required Function() onTap}) {
    return CustomButton(
      onTap: onTap,
      svgIconPath: AppVectors.googleIcon,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppVectors.googleIcon,
            height: AppSizes.large,
            width: AppSizes.large,
          ),
          SizedBox(width: AppSizes.small),
          Text(
            AppTexts.googleSignInButton,
            style: TextStyle(
              fontSize: AppSizes.normal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        width: 270,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: AppBorderRadius.all(AppSizes.small),
        ),
        child: Center(child: child),
      ),
    );
  }
}
