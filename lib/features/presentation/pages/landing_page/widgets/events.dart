import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trnk_ice/features/presentation/pages/landing_page/widgets/upload_events.dart';
import 'package:trnk_ice/features/presentation/pages/utility/snack_bar.dart';
import 'package:trnk_ice/firebase_service/fire_store_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final FireStoreService service = FireStoreService();
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[200],
        onPressed: () {
          _publishEvent();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: service.getEvents(),
            builder: ( context,  snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  SnackBars.showSnackBarError(context,'Error', '${snapshot.error}');
                });
                return Center(child: Text('Error,  ${snapshot.error}'),);
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  SnackBars.showSnackBarWarning(context,'Oops','No events available at the moment.');
                });
                return  const Center(child: Text('No events available at the moment.'),);
              }
              final events = snapshot.data!.docs;
              List<Map<String, dynamic>> eventList = [];

              //gather All events from the service
              for (var event in events){
                final serviceData = event.data() as Map<String,dynamic>;
                List<dynamic> events = serviceData['upcomingEvents'] ?? [];
                for(var event in events){
                  eventList.add(event as Map<String,dynamic>);
                }
              }

              return AlignedGridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: eventList.length,
                itemBuilder: (BuildContext context, int index) {
                  final  event = eventList[index];
                  //String docId = document.id;

                  //get events from each document

                  String title = event['title']??'';
                  String image = event['image'] ??'';
                  //Timestamp timestamp = data['timestamp'];

                  return Card(
                    elevation: 2,
                    shadowColor: Colors.grey.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            title,
                            style: GoogleFonts.robotoCondensed(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Image(image: NetworkImage(image),
                            height:300 ,
                            width:300 ,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );


                },);
            },

          )
      ),
    );
  }

  _publishEvent(){
    showModalBottomSheet(
      context: context, builder: (context)=> const UploadEvents(),);
}
}
