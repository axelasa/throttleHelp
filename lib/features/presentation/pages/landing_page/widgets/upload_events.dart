import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trnk_ice/core/common/widgets/app_button.dart';
import 'package:trnk_ice/core/common/widgets/app_color.dart';
import 'package:trnk_ice/core/common/widgets/app_input.dart';
import 'package:trnk_ice/core/common/widgets/screen_title.dart';
import 'package:trnk_ice/firebase_service/fire_store_service.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadEvents extends StatefulWidget {
  const UploadEvents({super.key});

  @override
  State<UploadEvents> createState() => _UploadEventsState();
}

class _UploadEventsState extends State<UploadEvents> {
  bool isLoading = false;
  String? documentName;
  PlatformFile? pickedEventFile;
  File? fileToDisplay;
  UploadTask? uploadTask;
  String? eventsUploadImage;
  String? event;

  final FireStoreService service = FireStoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController eventTitle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 16, 25, 08),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: ScreenTitle(title: 'Upload Event'),
            ),
            const SizedBox(height: 20),
            AppInput(
              label: 'Title',
              type: TextInputType.text,
              controller: eventTitle,
              validator: (value) =>
              value == null ? 'Please enter Event Title' : null,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          _requestPermissions();
                        },
                        icon: const Icon(Icons.camera_alt_outlined),
                      ),
                    ],
                  ),
                  if (pickedEventFile != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.file(
                          fileToDisplay!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '$documentName',
                          style: const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              textColor: Colors.white,
              backgroundColor: AppColors.mainColor,
              borderColor: AppColors.mainColor,
              text: 'Upload',
              onClicked: () async {
                await uploadFile();
                if (eventsUploadImage != null) {
                  service.addEvent(eventTitle.text, eventsUploadImage!);
                }
                //_navigateBack();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      _fileUpload();
    } else {
      debugPrint('Storage permission denied');
      return;
    }
  }

  void _fileUpload() async {
    // Request storage permissions
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      try {
        setState(() {
          isLoading = true;
        });

        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.media);
        if (result != null) {
          File file = File(result.files.single.path!);
          debugPrint(file.toString());

          String fileName = result.files.first.name;
          PlatformFile pickedFile = result.files.first;

          documentName = fileName;
          pickedEventFile = pickedFile;
          fileToDisplay = File('${pickedEventFile!.path}');

          // Call setState to update the UI with the selected image
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          return;
        }

        debugPrint('License File name: $documentName');
      } catch (e) {
        debugPrint(e.toString());
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Handle the case when the user does not grant permissions
      debugPrint("Storage permission denied");
    }
  }

  Future<void> uploadFile() async {
    if (documentName != null && fileToDisplay != null) {
      final ref = FirebaseStorage.instance.ref().child('events/${documentName!}');
      try {
        setState(() {
          isLoading = true;
        });

        uploadTask = ref.putFile(fileToDisplay!);

        uploadTask!.snapshotEvents.listen((taskSnapshot) {
          if (taskSnapshot.state == TaskState.success) {
            ref.getDownloadURL().then((downloadURL) {
              setState(() {
                isLoading = false;
                eventsUploadImage = downloadURL;
              });
            });
          }
        }).onError((error) {
          debugPrint('Error during upload: $error');
          setState(() {
            isLoading = false;
          });
        });
      } catch (e) {
        debugPrint('Error uploading file: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  _navigateBack(){
    Navigator.pop(context);
  }
}
