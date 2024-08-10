import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trnk_ice/core/common/widgets/app_button.dart';
import 'package:trnk_ice/core/common/widgets/app_color.dart';
import 'package:trnk_ice/core/common/widgets/screen_title.dart';
import 'package:trnk_ice/features/presentation/pages/auth/service/auth_service.dart';

import '../../../../core/common/untils/constant/constants.dart';
import '../../../../provider/user_provider.dart';
import '../auth/models/user_data.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  UserData? userdata;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    _updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // userdata = Provider
    //     .of<UserProvider>(context)
    //     .getUser;
    String? username = userdata?.name;
    var name = username?.split(' ').first;

    debugPrint('SNAPSHOT DATA: ${userdata?.name}');
    debugPrint('SNAPSHOT DATA: ${userdata?.nextOfKin}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: ScreenTitle(title: 'Home'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.successColor,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                NetworkImage(defaultProfilePicture),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Center(
                          child: Text(
                            'Hello $name',
                            style: GoogleFonts.akshar(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/emergency_information');
                            },
                            child: Card(
                              color: AppColors.secondaryColor,
                              // shadowColor: Colors.white38,
                              elevation: 1.5,
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    'Emergency Information',
                                    style: GoogleFonts.akshar(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/vehicle_data');
                            },
                            child: Card(
                              color: AppColors.secondaryColor,
                              // shadowColor: Colors.white38,
                              elevation: 1.5,
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    'Vehicle Information',
                                    style: GoogleFonts.akshar(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Card(
                            color: AppColors.secondaryColor,
                            // shadowColor: Colors.white38,
                            elevation: 1.5,
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Events Information',
                                  style: GoogleFonts.akshar(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppButton(
                          textColor: Colors.white,
                          backgroundColor: AppColors.warningColor,
                          borderColor: AppColors.warningColor,
                          text: 'Log out',
                          onClicked: () {
                            _auth.signOut();
                            _navigateToSignInPage();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _updateData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
    setState(() {
      userdata = userProvider.getUser;
    });
  }

  _navigateToSignInPage() {
    Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
  }
}
