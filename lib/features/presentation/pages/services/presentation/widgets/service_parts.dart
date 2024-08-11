import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/common/widgets/screen_title.dart';

class ServiceParts extends StatefulWidget {
  const ServiceParts({super.key});

  @override
  State<ServiceParts> createState() => _ServicePartsState();
}

class _ServicePartsState extends State<ServiceParts> {
  @override
  Widget build(BuildContext context) {
    CollectionReference mainStreamReference = FirebaseFirestore.instance
        .collection('services');
    DocumentReference mainDocumentReference = mainStreamReference.doc(
        'utkeUKSWnNsJNecVQwtt');
    CollectionReference streamSubCollection = mainDocumentReference.collection(
        'serviceParts');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(
                      width: 55,
                    ),
                    const Center(
                      child: ScreenTitle(
                        title: 'Service Parts',
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: streamSubCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: _showSnackBar('Error', ' ${snapshot.error}'),);
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: _showSnackBar('Error', 'No services available.'),);
                  }

                  final serviceParts = snapshot.data!.docs;
                  List<Map<String, dynamic>> servicePartsList = [];

                  //gather All mechanics from the service
                  for (var servicePart in serviceParts) {
                    final serviceData = servicePart.data() as Map<String,
                        dynamic>;
                    List<dynamic> serviceParts = serviceData['used'] ?? [];
                    for (var servicePart in serviceParts) {
                      servicePartsList.add(servicePart as Map<String, dynamic>);
                    }
                  }
                  return Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: servicePartsList.length,
                      itemBuilder: (context, index) {
                        final servicePart = servicePartsList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: ListTile(
                            title: Text('name: ${servicePart['name']}'),
                            subtitle: Text('contact: ${servicePart['phone']}'),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context,
                          int index) => const Divider(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _showSnackBar(String title, String message) {
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
}
