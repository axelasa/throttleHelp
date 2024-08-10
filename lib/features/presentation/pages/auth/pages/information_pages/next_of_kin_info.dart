import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trnk_ice/core/common/widgets/app_button.dart';
import 'package:trnk_ice/core/common/widgets/app_input.dart';
import 'package:trnk_ice/core/common/widgets/screen_title.dart';
import 'package:trnk_ice/home.dart';

import '../../../../../../core/common/widgets/app_color.dart';
import '../../../../../../core/common/widgets/app_font.dart';
import '../../../../../../provider/user_provider.dart';
import '../../models/user_data.dart';

class NextOfKinPage extends StatefulWidget {
  const NextOfKinPage({super.key});

  @override
  State<NextOfKinPage> createState() => _NextOfKinPageState();
}

class _NextOfKinPageState extends State<NextOfKinPage> {
  List<Map<String, dynamic>> nextOfKin = [];
  TextEditingController firstNameOfEmergencyContact1 = TextEditingController();
  TextEditingController lastNameOfEmergencyContact1 = TextEditingController();
  TextEditingController firstNameOfEmergencyContact2 = TextEditingController();
  TextEditingController lastNameOfEmergencyContact2 = TextEditingController();
  TextEditingController phoneNumberOfEmergencyContact1 =
      TextEditingController();
  TextEditingController phoneNumberOfEmergencyContact2 =
      TextEditingController();
  UserData? userdata;
  final _formKey = GlobalKey<FormState>();

  bool shouldShowAlert = false;
  bool shouldShowError = true;
  String alertMessage = '';
  String profileImage = '';

  @override
  void dispose() {
    firstNameOfEmergencyContact1.dispose();
    lastNameOfEmergencyContact1.dispose();
    phoneNumberOfEmergencyContact1.dispose();
    firstNameOfEmergencyContact2.dispose();
    lastNameOfEmergencyContact2.dispose();
    phoneNumberOfEmergencyContact2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userdata = Provider.of<UserProvider>(context).getUser;
    debugPrint('SNAPSHOT DATA: $userdata');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: ScreenTitle(title: 'Emergency Contact'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 15.0,
                right: 15,
                top: 10,
              ),
              child: Center(
                  child: Text(
                'Hello please fill in the fields below to continue.',
                style: TextStyle(
                    color: Colors.black45,
                    fontFamily: AppFont.font,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal),
              )),
            ),
            shouldShowAlert
                ? shouldShowError
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.errorColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          alertMessage,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15.0,
                              fontFamily: AppFont.font,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppColors.successColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          alertMessage,
                          style: const TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                              fontFamily: AppFont.font,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                : const SizedBox(),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppInput(
                          label: 'First Name of First Emergency Contact',
                          type: TextInputType.text,
                          controller: firstNameOfEmergencyContact1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppInput(
                          label: 'Last Name of First Emergency Contact',
                          type: TextInputType.text,
                          controller: lastNameOfEmergencyContact1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppInput(
                          label: 'Phone Number of second Emergency Contact',
                          type: TextInputType.phone,
                          controller: phoneNumberOfEmergencyContact1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppInput(
                          label: 'first Name of second Emergency Contact',
                          type: TextInputType.text,
                          controller: firstNameOfEmergencyContact2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppInput(
                          label: 'Last Name of First Emergency Contact',
                          type: TextInputType.text,
                          controller: lastNameOfEmergencyContact2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppInput(
                          label: 'Phone Number of second Emergency Contact',
                          type: TextInputType.phone,
                          controller: phoneNumberOfEmergencyContact2,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AppButton(
                          textColor: Colors.white,
                          backgroundColor: AppColors.mainColor,
                          borderColor: AppColors.mainColor,
                          text: 'Register',
                          onClicked: () async {
                            nextOfKin.add({
                              'name':
                                  '${firstNameOfEmergencyContact1.text} ${lastNameOfEmergencyContact1.text}',
                              'phoneNumber':
                                  phoneNumberOfEmergencyContact1.text,
                            });
                            nextOfKin.add({
                              'name':
                              '${firstNameOfEmergencyContact2.text} ${lastNameOfEmergencyContact2.text}',
                              'phoneNumber':
                              phoneNumberOfEmergencyContact2.text
                            });

                            if (_formKey.currentState!.validate()) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userdata!.uid)
                                  .set({
                                "uid": userdata!.uid,
                                "email": userdata!.email,
                                "name": userdata!.name,
                                "alias": userdata!.alias,
                                'idNumber': userdata!.idNumber,
                                'bloodGroup': userdata!.bloodGroup,
                                'phoneNumber': userdata!.phoneNumber,
                                'insurancePolicy.': userdata!.insurancePolicy,
                                'insurancePolicyNumber':
                                    userdata!.insurancePolicyNumber,
                                'preferredHospital':
                                    userdata!.preferredHospital,
                                'nhifNumber': userdata!.nhifNumber,
                                'nextOfKin': nextOfKin,
                                'motorCycleModel': userdata!.motorCycleModel,
                                'motorCycleRegistration':
                                    userdata!.motorCycleRegistration,
                                'motorCycleColor': userdata!.motorCycleColor,
                                'motorCycleMake':userdata!.motorCycleMake,
                                'motorCycleKenyaNumber':
                                    userdata!.motorCycleKenyaNumber,
                                'profileImage':profileImage,
                              });
                              _navigateToHomePage();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _updateData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  _navigateToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void giveErrorMessage({required String message}) {
    setState(() {
      shouldShowAlert = true;
      shouldShowError = true;
      alertMessage = message;
      Future.delayed(const Duration(seconds: 1000));
    });
  }

  void giveSuccessMessage({required String message}) {
    setState(() {
      shouldShowAlert = true;
      shouldShowError = false;
      alertMessage = message;
      Future.delayed(const Duration(seconds: 1000));
    });
  }
}
