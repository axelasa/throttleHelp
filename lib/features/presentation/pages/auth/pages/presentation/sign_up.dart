import 'package:flutter/material.dart';
import 'package:trnk_ice/core/common/widgets/app_button.dart';
import 'package:trnk_ice/core/common/widgets/app_input.dart';
import 'package:trnk_ice/core/common/widgets/screen_title.dart';
import 'package:trnk_ice/features/presentation/pages/auth/pages/presentation/sign_in.dart';

import '../../../../../../core/common/widgets/app_color.dart';
import '../../../../../../core/common/widgets/app_font.dart';
import '../../models/user_data.dart';
import '../../service/auth_service.dart';
import '../information_pages/vehicle_information.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController aliasController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool shouldShowAlert = false;
  bool shouldShowError = true;
  String alertMessage = '';

  String insurancePolicy = '';
  String insurancePolicyNumber = '';
  String preferredHospital = '';
  String nhifNumber = '';
  List<Map<String,dynamic>> nextOfKin = [];
  String motorCycleModel = '';
  String motorCycleRegistration = '';
  String motorCycleColor = '';
  String motorCycleMake = '';

  String motorCycleKenyaNumber = '';

  final AuthService _auth = AuthService();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    aliasController.dispose();
    idNumberController.dispose();
    bloodGroupController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: ScreenTitle(
                  title: 'Register',
                ),
              ),
              const SizedBox(
                height: 10,
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
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      AppInput(
                          label: 'Email',
                          type: TextInputType.text,
                          controller: emailController,
                          validator: (val) => val!.isEmpty
                              ? '*You must provide your email address'
                              : null,
                          onChanged: (val) {
                            emailController.text = val;
                          },),
                      const SizedBox(
                        height: 15,
                      ),
                      AppInput(
                          label: 'First Name',
                          type: TextInputType.text,
                          controller: firstNameController,
                          validator: (val) => val!.isEmpty
                              ? '*You must provide your first Name'
                              : null,
                          onChanged: (val) {
                            firstNameController.text = val;
                          },),
                      const SizedBox(
                        height: 15,
                      ),
                      AppInput(
                          label: 'Last Name',
                          type: TextInputType.text,
                          controller: lastNameController,
                          validator: (val) => val!.isEmpty
                              ? '*You must provide your last Name'
                              : null,
                          onChanged: (val) {
                            lastNameController.text = val;
                          },),
                      const SizedBox(
                        height: 15,
                      ),
                      AppInput(
                          label: 'Alias / Nickname',
                          type: TextInputType.text,
                          controller: aliasController,
                          onChanged: (val) {
                            aliasController.text = val;
                          },),
                      const SizedBox(
                        height: 15,
                      ),
                      AppInput(
                          label: 'Id Number',
                          type: TextInputType.number,
                          controller: idNumberController,
                          onChanged: (val) {
                            idNumberController.text = val;
                          },),
                      const SizedBox(
                        height: 15,
                      ),
                      AppInput(
                          label: 'Blood Group ( A+,A-,B+,B-,AB+,AB-,O+,O-)',
                          type: TextInputType.text,
                          controller: bloodGroupController,
                          validator: (val) => val!.isEmpty
                              ? '*provide your correct Blood Group'
                              : null,
                          onChanged: (val) {
                            bloodGroupController.text = val;
                          },),
                      const SizedBox(
                        height: 15,
                      ),
                      AppInput(
                          label: 'Phone Number',
                          type: TextInputType.phone,
                          controller: phoneNumberController,
                          validator: (val) => val!.isEmpty
                              ? '*provide your correct Phone Number'
                              : null,
                          onChanged: (val) {
                            phoneNumberController.text = val;
                          },),
                      const SizedBox(
                        height: 15,
                      ),
                      AppInput(
                          label: 'password',
                          type: TextInputType.text,
                          controller: passwordController,
                          validator: (val) => val!.length < 6
                              ? '*provide your correct Blood Group'
                              : null,
                          onChanged: (val) {
                            passwordController.text = val;
                          },),
                      const SizedBox(
                        height: 15,
                      ),
                      AppButton(
                        textColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        borderColor: AppColors.secondaryColor,
                        text: 'Next',
                        onClicked: () {
                          if (_formKey.currentState!.validate()) {
                            _register();
                          }
                        },
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontFamily: AppFont.font,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          TextButton(
                            onPressed: () {
                              _navigateToSignInPage();
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontFamily: AppFont.font,
                                color: AppColors.secondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline
                              ),
                            ),
                          )
                        ],
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

  _register() async {
    String resp = await _auth.registerUser(
      email: emailController.text,
      name: '${firstNameController.text} ${lastNameController.text}',
      password: passwordController.text,
      alias: aliasController.text,
      idNumber: idNumberController.text,
      bloodGroup: bloodGroupController.text,
      phoneNumber: phoneNumberController.text,
      insurancePolicy: insurancePolicy,
      insurancePolicyNumber: insurancePolicyNumber,
      preferredHospital: preferredHospital,
      nhifNumber: nhifNumber,
      nextOfKin: nextOfKin,
      motorCycleModel: motorCycleModel,
      motorCycleRegistration: motorCycleRegistration,
      motorCycleColor: motorCycleColor,
      motorCycleMake:motorCycleMake,
      motorCycleKenyaNumber: motorCycleKenyaNumber,
    );
    if (resp == 'Successfully registered') {
      giveSuccessMessage(message: "Successfully registered");
      Future.delayed(const Duration(seconds: 2), () async {
        _navigateToVehiclePage();
      });
    } else {
      giveErrorMessage(message: resp);
    }
  }

  _navigateToVehiclePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const VehicleInformationPage(),
      ),
    );
  }

  _navigateToSignInPage() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/sign_in', (route) => false);
  }

  void giveErrorMessage({required String message}) {
    setState(() {
      shouldShowAlert = true;
      shouldShowError = true;
      alertMessage = message;
      Future.delayed(const Duration(milliseconds: 1000));
    });
  }

  void giveSuccessMessage({required String message}) {
    setState(() {
      shouldShowAlert = true;
      shouldShowError = false;
      alertMessage = message;
      Future.delayed(const Duration(milliseconds: 1000));
    });
  }
}
