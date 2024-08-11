import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/common/widgets/screen_title.dart';

class Mechanics extends StatefulWidget {
  const Mechanics({super.key});

  @override
  State<Mechanics> createState() => _MechanicsState();
}

class _MechanicsState extends State<Mechanics> {
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
                        title: 'Mechanics',
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
                  return Center(child: _showSnackBar('Error', ' ${snapshot.error}'),);
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return  Center(child: _showSnackBar('Error','No services available.'),);
                }

                final services = snapshot.data!.docs;
                List<Map<String,dynamic>> mechanicsList =[];

                //gather All mechanics from the service
                for (var service in services){
                  final serviceData = service.data() as Map<String,dynamic>;
                  List<dynamic> mechanics = serviceData['mechanics'] ?? [];
                  for(var mechanic in mechanics){
                    mechanicsList.add(mechanic as Map<String,dynamic>);
                  }
                }
                return Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: mechanicsList.length,
                      itemBuilder: (context,index){
                      final mechanic = mechanicsList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
                        child:ListTile(
                          title: Text('name: ${mechanic['name']}'),
                          subtitle: Text('contact: ${mechanic['phone']}'),
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
   _showSnackBar(String title,String message) {
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

//this code will also return back data
//returns data in one combined card and not separated
// return ListView.separated(
// shrinkWrap: true,
// itemCount: services.length,
// itemBuilder: (context,index){
// final service = services[index].data() as Map<String,dynamic>;
// debugPrint('Here is the Service$service');
// List<dynamic> mechanics = service['mechnics'] ?? [];
//
// return Card(
// child: Column(
// children: mechanics.map<Widget>((mechanic) {
// return ListTile(
// title: Text('${mechanic['name']}'),
// subtitle: Text('${mechanic['phone']}'),
// );
// }).toList(),
// ),
// );
// }, separatorBuilder: (BuildContext context, int index)=> const Divider(),
// );
