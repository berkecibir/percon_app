import 'package:flutter/material.dart';
import 'package:percon_app/core/border/app_border_radius.dart';
import 'package:percon_app/core/sizes/app_sizes.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final Widget child;
  const CustomButton({required this.onTap, required this.child, super.key});

  factory CustomButton.googleSignIn({required Function() onTap}) {
    return CustomButton(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.login),
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
        height: 50,
        width: 275,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: AppBorderRadius.all(AppSizes.small),
        ),
        child: Center(child: child),
      ),
    );
  }
}
