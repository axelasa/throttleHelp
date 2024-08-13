import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trnk_ice/features/presentation/pages/utility/snack_bar.dart';

import '../../../../../../core/common/widgets/screen_title.dart';

class Garage extends StatefulWidget {
  const Garage({super.key});

  @override
  State<Garage> createState() => _GarageState();
}

class _GarageState extends State<Garage> {
  var stream = FirebaseFirestore.instance.collection('services').snapshots();

  @override
  Widget build(BuildContext context) {
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
                        title: 'Garages',
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: stream, builder: (context,snapshot){

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                }

                if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    SnackBars.showSnackBarError(context, 'Error', '${snapshot.error}');
                  });
                  return Center(child: Text('Error,  ${snapshot.error}'),);
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    SnackBars.showSnackBarWarning(context, 'Oops','No garages are available at the moment.');
                  });
                  return  const Center(child: Text('No garages are available.'),);
                }

                final services = snapshot.data!.docs;
                List<Map<String,dynamic>> garagesList =[];

                //gather All garages from the service
                for (var service in services){
                  final serviceData = service.data() as Map<String,dynamic>;
                  List<dynamic> garages = serviceData['garage'] ?? [];
                  for(var garage in garages){
                    garagesList.add(garage as Map<String,dynamic>);
                  }
                }
                return Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: garagesList.length,
                    itemBuilder: (context,index){
                      final garage = garagesList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
                        child:ListTile(
                          title: Text('name: ${garage['name']}'),
                          subtitle: Text('location: ${garage['location']}'),
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

