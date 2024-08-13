import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trnk_ice/features/presentation/pages/utility/snack_bar.dart';

import '../../../../../../core/common/widgets/screen_title.dart';

class Accessories extends StatefulWidget {
  const Accessories({super.key});

  @override
  State<Accessories> createState() => _AccessoriesState();
}

class _AccessoriesState extends State<Accessories> {
  @override
  Widget build(BuildContext context) {
    CollectionReference mainStreamReference = FirebaseFirestore.instance.collection('services');
    DocumentReference mainDocumentReference  = mainStreamReference.doc('utkeUKSWnNsJNecVQwtt');
    CollectionReference streamSubCollection=mainDocumentReference.collection('accessories');
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
                        title: 'Accessories',
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: streamSubCollection.snapshots(), builder: (context,snapshot){

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                }

                if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    SnackBars.showSnackBarError(context, 'Error', '${snapshot.error}');
                  });
                  return Center(child: Text('Error, ${snapshot.error}'),);
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    SnackBars.showSnackBarWarning(context, 'Oops','No accessories are available at the moment.');
                  });
                  return  const Center(child: Text('No services available.'),);
                }

                final accessories = snapshot.data!.docs;
                List<Map<String,dynamic>> accessoriesList =[];

                //gather All accessories from the service
                for (var accessory in accessories){
                  final serviceData = accessory.data() as Map<String,dynamic>;
                  List<dynamic> accessories = serviceData['used'] ?? [];
                  for(var accessory in accessories){
                    accessoriesList.add(accessory as Map<String,dynamic>);
                  }
                }
                return Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: accessoriesList.length,
                    itemBuilder: (context,index){
                      final accessory = accessoriesList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
                        child:ListTile(
                          title: Text('name: ${accessory['name']}'),
                          subtitle: Text('contact: ${accessory['phone']}'),
                        ),
                      );

                    }, separatorBuilder: (BuildContext context, int index)=> const Divider(),
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
}
