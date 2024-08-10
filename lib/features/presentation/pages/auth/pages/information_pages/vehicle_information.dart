import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/common/untils/constant/constants.dart';
import '../../../../../../core/common/widgets/app_button.dart';
import '../../../../../../core/common/widgets/app_color.dart';
import '../../../../../../core/common/widgets/app_font.dart';
import '../../../../../../core/common/widgets/app_input.dart';
import '../../../../../../core/common/widgets/screen_title.dart';
import '../../../../../../provider/user_provider.dart';
import '../../models/user_data.dart';
import 'insurance_information.dart';

class VehicleInformationPage extends StatefulWidget {
  const VehicleInformationPage({super.key});

  @override
  State<VehicleInformationPage> createState() => _VehicleInformationPageState();
}

class _VehicleInformationPageState extends State<VehicleInformationPage> {
  TextEditingController vehicleRegController = TextEditingController();
  TextEditingController vehicleMakeController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController motorCycleKenyaNumberController =
      TextEditingController();
  UserData? userdata;
  final _formKey = GlobalKey<FormState>();

  bool shouldShowAlert = false;
  bool shouldShowError = true;
  String alertMessage = '';
  String profileImage = '';

  @override
  void dispose() {
    vehicleRegController.dispose();
    vehicleMakeController.dispose();
    vehicleModelController.dispose();
    vehicleColorController.dispose();
    motorCycleKenyaNumberController.dispose();
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

    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: h! / 5,
                width: 287,
                child: const Image(image: AssetImage(motorcycle)),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 15.0,
              right: 15,
              top: 10,
            ),
            child: Center(child: ScreenTitle(title: 'Motorcycle Details')),
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
              child: SingleChildScrollView(
                child: Column(
                  //shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10.0, left: 20, right: 20),
                      child: AppInput(
                        label: 'Vehicle Reg Number',
                        type: TextInputType.text,
                        controller: vehicleRegController,
                        validator: (val) => val!.isEmpty
                            ? 'Vehicle registration cannot be empty'
                            : null,
                        onChanged: (val) {
                          vehicleRegController.text = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10.0, top: 5),
                      child: AppInput(
                        label: 'Vehicle model',
                        type: TextInputType.text,
                        controller: vehicleModelController,
                        validator: (val) => val!.isEmpty
                            ? 'Vehicle model cannot be empty'
                            : null,
                        onChanged: (val) {
                          vehicleModelController.text = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10.0, top: 5),
                      child: AppInput(
                        label: 'Vehicle Color',
                        type: TextInputType.text,
                        controller: vehicleColorController,
                        validator: (val) => val!.isEmpty
                            ? 'Vehicle color cannot be empty'
                            : null,
                        onChanged: (val) {
                          vehicleColorController.text = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10.0, top: 5),
                      child: AppInput(
                        label: 'Vehicle make',
                        type: TextInputType.text,
                        controller: vehicleMakeController,
                        validator: (val) => val!.isEmpty
                            ? 'Vehicle make cannot be empty'
                            : null,
                        onChanged: (val) {
                          vehicleMakeController.text = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15.0, top: 5),
                      child: AppInput(
                        label: 'Motorcycle Kenya Number',
                        type: TextInputType.text,
                        controller: motorCycleKenyaNumberController,
                        onChanged: (val) {
                          motorCycleKenyaNumberController.text = val;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 15.0, left: 15.0, bottom: 15.0),
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
                              'insurancePolicy.': userdata!.insurancePolicy,
                              'insurancePolicyNumber':
                                  userdata!.insurancePolicyNumber,
                              'preferredHospital': userdata!.preferredHospital,
                              'nhifNumber': userdata!.nhifNumber,
                              'nextOfKin': userdata!.nextOfKin,
                              'motorCycleModel': vehicleModelController.text,
                              'motorCycleRegistration':
                                  vehicleRegController.text,
                              'motorCycleColor': vehicleColorController.text,
                              'motorCycleMake':vehicleMakeController.text,
                              'motorCycleKenyaNumber':
                                  motorCycleKenyaNumberController.text,
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
          )
        ],
      )),
    );
  }

  _updateData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  _navigateToNextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const InsuranceInformationPage(),
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
