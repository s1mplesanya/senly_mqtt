import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senly/application/domain/services/auth_service.dart';
import 'package:senly/application/ui/themes/app_colors.dart';
import 'package:senly/application/ui/themes/app_text_style.dart';
import 'package:senly/resourses/svgs.dart';

class MessagesScreenWidget extends StatelessWidget {
  const MessagesScreenWidget({super.key});

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Contacts",
                            style: AppTextStyle.messagesTextStyle(context),
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
