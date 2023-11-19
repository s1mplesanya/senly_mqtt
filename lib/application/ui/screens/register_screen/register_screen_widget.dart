import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:senly/application/ui/screens/register_screen/register_screen_model.dart';
import 'package:senly/application/ui/themes/app_colors.dart';
import 'package:senly/application/ui/themes/app_text_style.dart';
import 'package:senly/resourses/svgs.dart';

class RegisterScreenWidget extends StatelessWidget {
  const RegisterScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _InputMainRegisterDataWidget(),
    );
  }
}

class _InputMainRegisterDataWidget extends StatelessWidget {
  const _InputMainRegisterDataWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<RegisterScreenModel>();
    return Center(
      child: GestureDetector(
        onTap: () => model.registerWithGoogle(context),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Google Sign In',
                  style: AppTextStyle.textStyle(
                    context,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(AppSvg.googleIcon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
