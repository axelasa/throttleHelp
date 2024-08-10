import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trnk_ice/core/common/widgets/app_input.dart';
import 'package:trnk_ice/core/common/widgets/screen_title.dart';
import '../../../../../../core/common/widgets/app_button.dart';
import '../../../../../../core/common/widgets/app_color.dart';
import '../../../../../../core/common/widgets/app_font.dart';
import '../../../../../../provider/user_provider.dart';
import '../../models/user_data.dart';
import 'next_of_kin_info.dart';

class InsuranceInformationPage extends StatefulWidget {
  const InsuranceInformationPage({super.key});

  @override
  State<InsuranceInformationPage> createState() =>
      _InsuranceInformationPageState();
}

class _InsuranceInformationPageState extends State<InsuranceInformationPage> {
  TextEditingController NHIFController = TextEditingController();
  TextEditingController insurancePolicyController = TextEditingController();
  TextEditingController insurancePolicyNumberController =
      TextEditingController();
  TextEditingController preferredHospitalController = TextEditingController();
  UserData? userdata;
  final _formKey = GlobalKey<FormState>();

  bool shouldShowAlert = false;
  bool shouldShowError = true;
  String alertMessage = '';
  String profileImage = '';

  @override
  void dispose() {
    NHIFController.dispose();
    insurancePolicyController.dispose();
    insurancePolicyNumberController.dispose();
    preferredHospitalController.dispose();
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15,
                  top: 10,
                ),
                child:
                    Center(child: ScreenTitle(title: 'Insurance Information')),
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
                  child: Column(
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Hello please fill in the fields below to continue.',
                            style: TextStyle(
                                color: Colors.black45,
                                fontFamily: AppFont.font,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppInput(
                            label: 'NHIF number',
                            type: TextInputType.number,
                            controller: NHIFController),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppInput(
                            label: 'Medical Insurance Company',
                            type: TextInputType.text,
                            controller: insurancePolicyController),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppInput(
                            label: 'Policy Number',
                            type: TextInputType.text,
                            controller: insurancePolicyNumberController),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppInput(
                            label: 'Preferred Hospital',
                            type: TextInputType.text,
                            controller: preferredHospitalController),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 15.0,
                          left: 15.0,
                          bottom: 15.0,
                        ),
                        child: AppButton(
                          textColor: Colors.white,
                          backgroundColor: AppColors.mainColor,
                          borderColor: AppColors.mainColor,
                          text: 'Continue',
                          onClicked: () async {
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
                                'insurancePolicy.': insurancePolicyController.text,
                                'insurancePolicyNumber':
                                    insurancePolicyNumberController.text,
                                'preferredHospital':
                                    preferredHospitalController.text,
                                'nhifNumber': NHIFController.text,
                                'nextOfKin': userdata!.nextOfKin,
                                'motorCycleModel': userdata!.motorCycleModel,
                                'motorCycleRegistration':
                                    userdata!.motorCycleRegistration,
                                'motorCycleColor': userdata!.motorCycleColor,
                                'motorCycleMake': userdata!.motorCycleMake,
                                'motorCycleKenyaNumber':
                                    userdata!.motorCycleKenyaNumber,
                                'profileImage':profileImage,
                              });
                              _navigateToNextPage();
                            }
                          },
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
  }

  _navigateToNextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const NextOfKinPage(),
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
