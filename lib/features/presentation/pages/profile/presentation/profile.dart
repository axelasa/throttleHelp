import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trnk_ice/core/common/untils/custom_alert_dialog.dart';
import '../../../../../core/common/untils/constant/constants.dart';
import '../../../../../core/common/widgets/app_color.dart';
import '../../../../../core/common/widgets/app_font.dart';
import '../../../../../core/common/widgets/screen_title.dart';
import '../../../../../provider/user_provider.dart';
import '../../auth/models/user_data.dart';
import '../../auth/service/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? userdata;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    _updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Center(
                      child: ScreenTitle(title: 'Profile'),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        logoutDialog();
                      },
                      icon: const Icon(
                        Icons.logout_outlined,
                        size: 30,
                        color: Colors.amber,
                      ))
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.successColor,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(defaultProfilePicture),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Center(
                      child: Text(
                        'Hello ${userdata?.name}',
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
                height: 5,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Name:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.font),
                                  ),
                                  Text(
                                    userdata?.name ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFont.font),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Blood Group:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.font),
                                  ),
                                  Text(
                                    userdata?.bloodGroup ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFont.font),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Phone Number:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.font),
                                  ),
                                  Text(
                                    userdata?.phoneNumber ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFont.font),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Id Number:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.font),
                                  ),
                                  Text(
                                    userdata?.idNumber ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFont.font),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Alias :',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.font),
                                  ),
                                  Text(
                                    userdata?.alias ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFont.font),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'PBAK No: :',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.font),
                                  ),
                                  Text(
                                    userdata?.motorCycleKenyaNumber ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFont.font),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: ScreenTitle(
                          title: 'Insurance Details',
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Card(
                        color: Colors.white,
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Policy Provider:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.font),
                                  ),
                                  Text(
                                    userdata?.insurancePolicy ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFont.font),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Member Number:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.font),
                                  ),
                                  Text(
                                    userdata?.insurancePolicyNumber ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFont.font),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'NHIF:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.font),
                                  ),
                                  Text(
                                    userdata?.nhifNumber ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFont.font),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Preferred Hospital:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppFont.font),
                                  ),
                                  Text(
                                    userdata?.preferredHospital ?? "",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFont.font),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

  void logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Logout',
          message: 'Are you Sure You want to Logout?',
          positiveBtnText: 'Yes',
          negativeBtnText: 'Cancel',
          onPostivePressed: () {
            _auth.signOut();
            _navigateToSignInPage();
          },
          onNegativePressed: () {
            return;
          },
        );
      },
    );
  }
  _navigateToSignInPage() {
    Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
  }
}
