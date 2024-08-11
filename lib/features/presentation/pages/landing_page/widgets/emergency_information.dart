import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:trnk_ice/core/common/widgets/app_button.dart';
import 'package:trnk_ice/core/common/widgets/app_input.dart';
import 'package:trnk_ice/core/common/widgets/screen_title.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/common/widgets/app_color.dart';
import '../../../../../provider/user_provider.dart';
import '../../auth/models/user_data.dart';

class EmergencyInformation extends StatefulWidget {
  const EmergencyInformation({super.key});

  @override
  State<EmergencyInformation> createState() => _EmergencyInformationState();
}

class _EmergencyInformationState extends State<EmergencyInformation> {
  late CollectionReference<Map<String, dynamic>> _collectionReference;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateData();
  }

  UserData? userdata;

  @override
  Widget build(BuildContext context) {
    // userdata = Provider.of<UserProvider>(context).getUser;
    _collectionReference = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text('Emergency Information',
      //   style: GoogleFonts.akshar(
      //     textStyle: const TextStyle(
      //       color: Colors.black,
      //       fontSize: 16,
      //       fontWeight: FontWeight.w400,
      //     ),
      //   ),
      //   textAlign: TextAlign.center,
      // ),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
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
                        title: 'Emergency Information',
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: _collectionReference.doc(userdata?.uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  }

                  if (snapshot.hasError) {
                    return Center(child: _showFailedSnackBar('Error', ' ${snapshot.error}'),);
                  }

                  if (!snapshot.hasData) {
                    return  Center(
                      child: _showWarningSnackBar('Sorry','No data found'),
                    );
                  }
                  if (snapshot.data!.exists) {

                    Map<String, dynamic>? data =
                    snapshot.data!.data() as Map<String, dynamic>?;
                    List<Map<String, dynamic>> contactsList = [];
                    if (data != null && data.containsKey('nextOfKin')) {
                      List<dynamic> contacts = data['nextOfKin'];
                      for (var contact in contacts) {
                        if (contact is Map<String, dynamic>) {
                          contactsList.add(contact);
                          debugPrint('HERE IS THE CONTACTS $contactsList');
                        }
                      }
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: ListView.separated(
                          itemCount: contactsList.length,
                          itemBuilder: (context, i) {
                            Map<String, dynamic> contact = contactsList[i];
                            debugPrint('Contact: $contact');
                            return Slidable(
                              closeOnScroll: true,
                              startActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      //make Phone call
                                      final String _phoneNumber =
                                      contact['phoneNumber'];
                                      makeCall(_phoneNumber);
                                    },
                                    backgroundColor: AppColors.mainColor,
                                    icon: Icons.phone,
                                    label: 'Call',
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      ///edit number
                                      editData(contactsList,contact);
                                    },
                                    backgroundColor: AppColors.warningColor,
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      ///Delete Contact
                                      contactsList.removeWhere((key) => key['name'] == contact['name'] && key['phoneNumber'] == contact['phoneNumber']);
                                      DocumentReference<Map<String, dynamic>> docRef =_collectionReference.doc(userdata?.uid);
                                      docRef
                                          .update({'nextOfKin': contactsList})
                                          .then((value) {
                                        // Handle Success
                                        _showSnackBar('Success','Contact Deleted Successfully');
                                      })
                                          .catchError((error) {
                                        debugPrint('Failed to delete contact: $error');
                                      });
                                    },
                                    backgroundColor: AppColors.errorColor,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 0.3,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: ListTile(
                                    title: Text(contact['name']),
                                    subtitle: Text(contact['phoneNumber']),
                                    leading: const Icon(
                                      Icons.person,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              FloatingActionButton(
                  foregroundColor: AppColors.mainColor,
                  backgroundColor: AppColors.mainColor,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_emergency_information');
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _updateData() async {
    UserProvider userProvider = Provider.of<UserProvider>(context,
        listen: false); // Changed listen to false
    await userProvider.refreshUser();
    setState(() {
      userdata = userProvider.getUser;
    });
  }

  void makeCall(String phoneNumber) async {
    final Uri call = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(call)) {
      await launchUrl(call);
    }
  }

  //edit user data,
  void editData(List <Map<String,dynamic>> contactList ,Map<String, dynamic> contact) {
    final _formKey = GlobalKey<FormState>();

    TextEditingController nameController =
    TextEditingController(text: contact['name']);
    TextEditingController phoneController =
    TextEditingController(text: contact['phoneNumber']);

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 500,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInput(
                      label: 'name',
                      type: TextInputType.name,
                      controller: nameController,
                      validator: (val) =>
                      val!.isEmpty
                          ? '* you need to provide a name'
                          : null,
                      onChanged: (val) {
                        nameController.text = val;
                      },
                    ),
                    const SizedBox(height: 15,),
                    AppInput(
                      label: 'phone Number',
                      type: TextInputType.phone,
                      controller: phoneController,
                      validator: (val) =>
                      val!.isEmpty
                          ? '* you need to provide a phone Number'
                          : null,
                      onChanged: (val) {
                        phoneController.text = val;
                      },
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AppButton(
                            textColor: Colors.white,
                            backgroundColor: AppColors.secondaryColor,
                            borderColor: AppColors.secondaryColor,
                            text: 'Cancel',
                            onClicked: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: AppButton(
                            textColor: Colors.white,
                            backgroundColor: AppColors.mainColor,
                            borderColor: AppColors.mainColor,
                            text: 'Save',
                            onClicked: () {
                              if(_formKey.currentState!.validate()){
                                final String newName = nameController.text;
                                final String newPhoneNumber = phoneController.text;

                                // Update the contact in Firebase FireStore
                                _updateContact(contactList,contact, newName, newPhoneNumber);

                                Navigator.pop(context);
                              }
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
    );
  }

  void _updateContact(List <Map<String,dynamic>> contactList, Map<String, dynamic> contact, String newName, String newPhoneNumber){
    // Update the contact in Firebase Firestore

    ///update the List Of Contacts
    contactList.where((key) => key['name'] == contact['name'] && key['phoneNumber'] == contact['phoneNumber']).forEach((c) {
      c.update(('name'), (value) => newName, ifAbsent: () => newName);
      c.update(('phoneNumber'), (value) => newPhoneNumber, ifAbsent: () => newPhoneNumber);
    });
    DocumentReference<Map<String, dynamic>> docRef =_collectionReference.doc(userdata?.uid);
    docRef
        .update({'nextOfKin': contactList})
        .then((value) {
      _showSnackBar('Success','Contact Updated Successfully');
    })
        .catchError((error) {
      debugPrint('Failed to update contact: $error');
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

  _showFailedSnackBar(String title,String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: ContentType.failure,
          )
      ),
    );

  }

  _showWarningSnackBar(String title,String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: ContentType.warning,
          )
      ),
    );

  }

}



