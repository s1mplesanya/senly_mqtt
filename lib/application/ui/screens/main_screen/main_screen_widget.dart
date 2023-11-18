import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:senly/application/ui/screens/main_screen/main_screen_model.dart';
import 'package:senly/application/ui/themes/app_colors.dart';
import 'package:senly/application/ui/themes/app_text_style.dart';
import 'package:senly/resourses/images.dart';
import 'package:senly/resourses/svgs.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final model = context.read<MainScreenModel>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'CENTRAL MOSCOW',
          style: AppTextStyle.mainTextStyle(context),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const _LayersWidget(),
        leadingWidth: 68,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.color5.withOpacity(0.7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  Images.crown,
                  color: AppColors.color2,
                  height: 17,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) {
              model.mapControllerCompleter.complete(controller);
            },
          ),
          // if (true)
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Padding(
          //       padding: const EdgeInsets.only(
          //         bottom: 50,
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(right: 18, left: 18),
          //             child: DecoratedBox(
          //               decoration: BoxDecoration(
          //                 color: AppColors.color5.withOpacity(0.7),
          //                 borderRadius: BorderRadius.circular(18),
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(12.0),
          //                 child: Image.asset(
          //                   Images.crown,
          //                   color: AppColors.color2,
          //                   height: 17,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          const AllButtonsWidget(),
        ],
      ),
    );
  }
}

class AllButtonsWidget extends StatelessWidget {
  const AllButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentTab =
        context.select((MainScreenModel model) => model.currentTabIndex);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.only(
            //       bottom: 50,
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(right: 18, left: 18),
            //           child: DecoratedBox(
            //             decoration: BoxDecoration(
            //               color: AppColors.color5.withOpacity(0.7),
            //               borderRadius: BorderRadius.circular(18),
            //             ),
            //             child: Padding(
            //               padding: const EdgeInsets.all(12.0),
            //               child: Image.asset(
            //                 Images.crown,
            //                 color: AppColors.color2,
            //                 height: 17,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ButtonWidget(
                  iconPath: AppSvg.messages,
                  mainIconPath: currentTab,
                ),
                const SizedBox(
                  width: 34,
                ),
                _ButtonWidget(
                  iconPath: AppSvg.planet,
                  mainIconPath: currentTab,
                ),
                const SizedBox(
                  width: 34,
                ),
                _ButtonWidget(
                  iconPath: AppSvg.profile,
                  mainIconPath: currentTab,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  final String iconPath;
  final String mainIconPath;

  const _ButtonWidget({
    required this.iconPath,
    required this.mainIconPath,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainScreenModel>();

    final isMainButton = iconPath == mainIconPath;
    final double size = isMainButton ? 58 : 48;
    final double margin = isMainButton && iconPath == AppSvg.planet ? 120 : 50;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: margin),
      width: size,
      height: size,
      child: FloatingActionButton(
        backgroundColor: AppColors.color5,
        splashColor: AppColors.color5,
        onPressed: () => model.setCurrentTabIndex(iconPath),
        elevation: 1,
        enableFeedback: false,
        child: SvgPicture.asset(
          iconPath,
          width: isMainButton ? 34 : 24,
          height: isMainButton ? 34 : 24,
          color: isMainButton ? AppColors.main : AppColors.color2,
        ),
      ),
    );
  }
}

class _LayersWidget extends StatelessWidget {
  const _LayersWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.color5.withOpacity(0.7),
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.only(left: 18),
      child: Image.asset(
        Images.layers,
        color: AppColors.color2,
        height: 23,
      ),
    );
  }
}
