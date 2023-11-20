import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:senly/application/domain/services/auth_service.dart';
import 'package:senly/application/domain/services/user_service.dart';
import 'package:senly/application/ui/screens/user_screen/user_screen_model.dart';
import 'package:senly/application/ui/themes/app_colors.dart';
import 'package:senly/application/ui/themes/app_text_style.dart';
import 'package:senly/resourses/svgs.dart';

class UserScreenWidget extends StatelessWidget {
  const UserScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final authService = AuthService();
    // final model = context.read<UserScreenModel>();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.color5.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: SizedBox(
          height: height * 0.9,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 46,
                ),
                Row(
                  children: [
                    const _SignOutPopUpWidget(),
                    const SizedBox(
                      width: 21,
                    ),
                    SvgPicture.asset(
                      AppSvg.ghost,
                      height: 24,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 19,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserService.user?.displayName ?? "name",
                            style: AppTextStyle.nameTextStyle(context),
                          ),
                          const SizedBox(
                            height: 26,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppSvg.upload,
                                width: 14,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  'Sen.ly/${authService.user?.providerData[0].email}'
                                      .toUpperCase(),
                                  style: AppTextStyle.uploadTextStyle(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (authService.user?.providerData[0].photoURL != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: SizedBox(
                          height: 85,
                          width: 85,
                          child: Image.network(
                            authService.user!.providerData[0].photoURL!,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 42,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignOutPopUpWidget extends StatelessWidget {
  const _SignOutPopUpWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<UserScreenModel>();
    return Theme(
      data: ThemeData(
        splashFactory: NoSplash.splashFactory,
      ),
      child: PopupMenuButton(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10,
        constraints: const BoxConstraints(maxWidth: 150),
        enableFeedback: false,
        icon: SvgPicture.asset(
          AppSvg.settings,
          height: 30,
        ),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: 'logout',
            child: Text(
              'Log out',
              style: AppTextStyle.logoutTextStyle(context),
            ),
          ),
        ],
        onSelected: (value) async {
          if (value == 'logout') {
            model.signOut();
          }
        },
      ),
    );
  }
}
