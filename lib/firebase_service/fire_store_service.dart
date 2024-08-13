import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreService {
  final CollectionReference events = FirebaseFirestore.instance.collection('events');

  // Create event
  Future<void> addEvent( String name, String image) async {
    try {
      await events.add({
        'upcomingEvents': FieldValue.arrayUnion([
          {
            'title': name,
            'image': image,
          }
        ]),
      });
      debugPrint('Event added successfully!');
    } catch (e) {
      debugPrint('Error adding event: $e');
    }
  }

  // Read Events
  Stream<QuerySnapshot> getEvents() {
    return events.snapshots();
  }

  // Delete event
  Future<void> deleteEvent(String docId) {
    return events.doc(docId).delete();
  }
}
