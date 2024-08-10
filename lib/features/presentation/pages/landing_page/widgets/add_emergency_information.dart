import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trnk_ice/core/common/widgets/screen_title.dart';

import '../../../../../core/common/widgets/app_button.dart';
import '../../../../../core/common/widgets/app_color.dart';
import '../../../../../core/common/widgets/app_font.dart';
import '../../../../../core/common/widgets/app_input.dart';
import '../../../../../provider/user_provider.dart';
import '../../auth/models/user_data.dart';

class AddEmergencyInformation extends StatefulWidget {
  const AddEmergencyInformation({super.key});

  @override
  State<AddEmergencyInformation> createState() =>
      _AddEmergencyInformationState();
}

class _AddEmergencyInformationState extends State<AddEmergencyInformation> {
  List<Map<String, dynamic>> nextOfKin = [];
  TextEditingController firstNameOfEmergencyContact = TextEditingController();
  TextEditingController lastNameOfEmergencyContact = TextEditingController();
  TextEditingController phoneNumberOfEmergencyContact = TextEditingController();

  UserData? userdata;
  final _formKey = GlobalKey<FormState>();

  bool shouldShowAlert = false;
  bool shouldShowError = true;
  String alertMessage = '';
  String profileImage = '';

  @override
  void dispose() {
    firstNameOfEmergencyContact.dispose();
    lastNameOfEmergencyContact.dispose();
    phoneNumberOfEmergencyContact.dispose();
    super.dispose();
  }

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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_outlined),
                    ),
                    const Center(
                      child: ScreenTitle(
                        title: 'Add Emergency Info',
                      ),
                    ),
                  ],
                ),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppInput(
                            label: 'First Name of First Emergency Contact',
                            type: TextInputType.text,
                            controller: firstNameOfEmergencyContact,
                            validator: (val) => val!.isEmpty
                                ? '*You have to fill in the first name'
                                : null,
                            onChanged: (val) {
                              firstNameOfEmergencyContact.text = val;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppInput(
                            label: 'Last Name of First Emergency Contact',
                            type: TextInputType.text,
                            controller: lastNameOfEmergencyContact,
                            validator: (val) => val!.isEmpty
                                ? '*You have to fill in the last name'
                                : null,
                            onChanged: (val) {
                              lastNameOfEmergencyContact.text = val;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppInput(
                            label: 'Phone Number of second Emergency Contact',
                            type: TextInputType.phone,
                            controller: phoneNumberOfEmergencyContact,
                            validator: (val) => val!.isEmpty
                                ? '*You have to provide a phone number'
                                : null,
                            onChanged: (val) {
                              phoneNumberOfEmergencyContact.text = val;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppButton(
                            textColor: Colors.white,
                            backgroundColor: AppColors.mainColor,
                            borderColor: AppColors.mainColor,
                            text: 'Add',
                            onClicked: () async {
                              if (_formKey.currentState!.validate()) {
                                //here I am fetching the existing emergency data
                                DocumentSnapshot userDataSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userdata?.uid)
                                        .get();

                                List<Map<String, dynamic>> existingNextOfKin =
                                    [];
                                if (userDataSnapshot.exists) {
                                  existingNextOfKin =
                                      List<Map<String, dynamic>>.from(
                                          userDataSnapshot.get('nextOfKin') ??
                                              []);


                                }
                                if(!userDataSnapshot.exists){

                                }
                                // Checking for duplicate phone numbers
                                bool isDuplicate = existingNextOfKin.any(
                                    (contact) =>
                                        contact['phoneNumber'] ==
                                        phoneNumberOfEmergencyContact.text);

                                if (isDuplicate) {
                                  // Show error message if the phone number already exists
                                  giveErrorMessage(
                                      message:
                                          'A user with this phone number already exists');
                                  return;
                                } else {
                                  // Append new emergency contact information to the existing array
                                  existingNextOfKin.add({
                                    'name':
                                        '${firstNameOfEmergencyContact.text} ${lastNameOfEmergencyContact.text}',
                                    'phoneNumber':
                                        phoneNumberOfEmergencyContact.text,
                                    'principal':userdata!.uid
                                  });

                                  // Update FireStore document with the updated nextOfKin array
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userdata!.uid)
                                      .update({
                                    'nextOfKin': existingNextOfKin,
                                  });
                                  // Show success message
                                  _showSnackBar('Success','Contact Added Successfully');
                                }
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
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

  void _showSnackBar(String title,String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: ContentType.success,
          )
      ),
    );
  }

  void giveErrorMessage({required String message}) {
    setState(() {
      shouldShowAlert = true;
      shouldShowError = true;
      alertMessage = message;
      Future.delayed(const Duration(milliseconds: 2000));
    });
  }

  void giveSuccessMessage({required String message}) {
    setState(() {
      shouldShowAlert = true;
      shouldShowError = false;
      alertMessage = message;
      Future.delayed(const Duration(milliseconds: 2000));
    });
  }
}
