import 'package:flutter/material.dart';
import 'package:trnk_ice/features/presentation/pages/feeds/presentation/feeds.dart';
import 'package:trnk_ice/features/presentation/pages/landing_page/landing_page.dart';
import 'package:trnk_ice/features/presentation/pages/services/presentation/services.dart';

import 'core/common/widgets/app_color.dart';
import 'core/common/widgets/app_font.dart';
import 'features/presentation/pages/profile/presentation/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentWidgetPage = const LandingPage();

    switch (selectedIndex) {
      case 0:
        currentWidgetPage = const LandingPage();
        break;
      case 1:
        currentWidgetPage = const ServicePage();
        break;

      case 2:
        currentWidgetPage = const FeedsPage();
        break;

      case 3:
        currentWidgetPage = const ProfilePage();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Row(children: [
        Expanded(
          child: navBarItem(Icons.home_outlined, 0, 'Home', true),
        ),
        Expanded(
          child: navBarItem(Icons.miscellaneous_services_outlined, 1, 'Services', true),
        ),
        Expanded(
          child: navBarItem(Icons.add_chart_outlined, 2, 'Feeds', true),
        ),
        Expanded(
          child: navBarItem(Icons.person_3_sharp, 3, 'Profile', true),
        )
      ]),
      body: currentWidgetPage,
    );
  }

  Widget navBarItem(IconData icon, int index, String label, bool visible) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Container(
          height: 56,
          width: MediaQuery.of(context).size.width / 3,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26.0,
                color: index == selectedIndex
                    ? AppColors.mainColor
                    : const Color(0xff999999),
              ),
              Text(
                label,
                style: TextStyle(
                  color: index == selectedIndex
                      ? AppColors.mainColor
                      : const Color(0xff999999),
                  fontSize: 13,
                  fontFamily: AppFont.font,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
